--soboku: 만드라코네

function c8082.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8082+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8082.spco)
	e1:SetTarget(c8082.sptg)
	e1:SetOperation(c8082.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(8082,ACTIVITY_SPSUMMON,c8082.cunfilter)

	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c8082.filter)
	c:RegisterEffect(e2)

	--immune trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8082,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c8082.itco)
	e3:SetOperation(c8082.itop)
	c:RegisterEffect(e3)
	
end

--special summon
function c8082.cunfilter(c)
	return c:IsSetCard(0x2136)
end
function c8082.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(8082,tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8082.splm)
	Duel.RegisterEffect(e1,tp)
end
function c8082.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2136)
end

function c8082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,8082,0x2136,0x21,3,1300,800,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c8082.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,8082,0x2136,0x21,3,1300,800,RACE_PLANT,ATTRIBUTE_WIND) then
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
function c8082.filter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--immune trap
function c8082.itcofilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
		and not (c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_EQUIP) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_RITUAL))
end
function c8082.itco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8082.itcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8082.itcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8082.itop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c8082.itfilter)
	e1:SetValue(c8082.opvlfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end	
--immune trap / TARGET and VALUE
function c8082.itfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2136)
end
function c8082.opvlfilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
