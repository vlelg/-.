--soboku: 만드라코상

function c8083.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8083+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8083.spco)
	e1:SetTarget(c8083.sptg)
	e1:SetOperation(c8083.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(8083,ACTIVITY_SPSUMMON,c8083.cunfilter)

	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c8083.filter)
	c:RegisterEffect(e2)
	
	--special summon e3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8083,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c8083.sscn)
	e3:SetTarget(c8083.sstg)
	e3:SetOperation(c8083.ssop)
	c:RegisterEffect(e3)
	
end


--special summon
function c8083.cunfilter(c)
	return c:IsSetCard(0x2136)
end
function c8083.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(8083,tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8083.splm)
	Duel.RegisterEffect(e1,tp)
end
function c8083.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2136)
end

function c8083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,8083,0x2136,0x21,2,800,1300,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c8083.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,8083,0x2136,0x21,2,800,1300,RACE_PLANT,ATTRIBUTE_WIND) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end

--immune spell
function c8083.filter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--e3
function c8083.sscn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_DESTROY) or c:IsReason(REASON_EFFECT) or c:IsReason(REASON_COST) or c:IsReason(REASON_RELEASE))
			and c:GetPreviousControler()==tp
			and c:IsPreviousLocation(LOCATION_MZONE)
end

function c8083.sstgfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2136) and not c:IsCode(8083)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x2136,0x21,0,0,0,RACE_PLANT,ATTRIBUTE_WIND)
end
function c8083.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8083.sstgfilter,tp,LOCATION_REMOVED,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end

function c8083.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c8083.sstgfilter,tp,LOCATION_REMOVED,0,nil,tp)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tg=sg:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		tg:RegisterFlagEffect(8083,RESET_EVENT+0x47c0000,0,1,fid)
		tg=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENCE)
	Duel.ConfirmCards(1-tp,sg)
	sg:KeepAlive()
end
