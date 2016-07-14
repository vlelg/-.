--Soboku: 알라우네상

function c8076.initial_effect(c)
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8076+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8076.spco)
	e1:SetTarget(c8076.sptg)
	e1:SetOperation(c8076.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(8076,ACTIVITY_SPSUMMON,c8076.cunfilter)

	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c8076.filter)
	c:RegisterEffect(e2)
	
	--sendto hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8076,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCost(c8076.thco)
	e3:SetTarget(c8076.thtg)
	e3:SetOperation(c8076.thop)
	c:RegisterEffect(e3)
	
end

--special summon
function c8076.cunfilter(c)
	return c:IsSetCard(0x2136)
end
function c8076.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(8076,tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8076.splm)
	Duel.RegisterEffect(e1,tp)
end
function c8076.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2136)
end

function c8076.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,8076,0x2136,0x21,4,1700,400,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c8076.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,8076,0x2136,0x21,4,1700,400,RACE_PLANT,ATTRIBUTE_WIND) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end

--immune spell
function c8076.filter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--sendto hand
function c8076.thcofilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
		and not (c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_EQUIP) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_RITUAL))
end
function c8076.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8076.thcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8076.thcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8076.thtgfilter(c)
	return (c:IsSetCard(0x2136) or c:IsCode(24094653)) and c:IsAbleToHand()
end
function c8076.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c8076.thtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8076.thtgfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8076.thtgfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c8076.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
