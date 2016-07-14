--MMJ: Shin-rai rei

function c8102.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c8102.filter,aux.NonTuner(nil),1)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c8102.atvl)
	e1:SetCondition(c8102.atcn)
	c:RegisterEffect(e1)
	
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8102,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c8102.daco)
	e2:SetTarget(c8102.datg)
	e2:SetOperation(c8102.daop)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8102,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c8102.sptg)
	e3:SetOperation(c8102.spop)
	c:RegisterEffect(e3)
	
end

function c8102.filter(c)
	return c:IsSetCard(0x2135) and c:IsLevelAbove(4)
end

--act limit
function c8102.atvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

function c8102.atcn(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

--direct attack
function c8102.dacofilter(c)
	return c:IsSetCard(0x2135) and c:IsAbleToDeckAsCost()
		and not c:IsType(TYPE_SYNCHRO)
end
function c8102.daco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8102.dacofilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_TODECK)
	local g=Duel.SelectMatchingCard(tp,c8102.dacofilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c8102.datgfilter(c)
	return c:IsSetCard(0x2135) and c:IsFaceup()
		and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c8102.tgtgfilter(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c8102.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c8102.datgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8102.datgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c8102.datgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_OATH)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetLabel(g:GetFirst():GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c8102.tgtgfilter)
	Duel.RegisterEffect(e2,tp)
end

function c8102.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

--special summon
function c8102.sptgfilter(c,e,tp)
	return c:IsSetCard(0x2135) and c:IsType(TYPE_TUNER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8102.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8102.sptgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c8102.sptgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c8102.sptgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c8102.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

