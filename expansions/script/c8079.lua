--Soboku: 기도의 아이

function c8079.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8079+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8079.spco)
	e1:SetTarget(c8079.sptg)
	e1:SetOperation(c8079.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(8079,ACTIVITY_SPSUMMON,c8079.cunfilter)

	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c8079.filter)
	c:RegisterEffect(e2)
	
	--sendto grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8079,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c8079.tgcn)
	e3:SetTarget(c8079.tgtg)
	e3:SetOperation(c8079.tgop)
	c:RegisterEffect(e3)
	
end

--special summon
function c8079.cunfilter(c)
	return c:IsSetCard(0x2136)
end
function c8079.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(8079,tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8079.splm)
	Duel.RegisterEffect(e1,tp)
end
function c8079.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2136)
end

function c8079.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,8079,0x2136,0x21,1,100,2000,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c8079.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,8079,0x2136,0x21,1,100,2000,RACE_PLANT,ATTRIBUTE_WIND) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENCE)
	end
end

--immune spell
function c8079.filter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--search
function c8079.tgcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_DESTROY) or c:IsReason(REASON_EFFECT) or c:IsReason(REASON_COST) or c:IsReason(REASON_RELEASE))
			and c:GetPreviousControler()==tp
			and c:IsPreviousLocation(LOCATION_MZONE)
end

function c8079.tgtgfilter(c)
	return (c:IsSetCard(0x2136) or c:IsCode(24094653)) and c:IsAbleToGrave()
end
function c8079.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8079.tgtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c8079.tgop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c8079.tgtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end