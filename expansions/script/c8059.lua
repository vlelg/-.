--MMJ Reimusha
function c8059.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c8059.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot be targeted
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c8059.cntgvl)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c8059.alvl)
	e2:SetCondition(c8059.alcon)
	c:RegisterEffect(e2)
	--send to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8059,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c8059.tdco)
	e3:SetTarget(c8059.tdtg)
	e3:SetOperation(c8059.tdop)
	c:RegisterEffect(e3)
end

--synchro summon
function c8059.tfilter(c)
	return c:IsSetCard(0x2135) and c:IsType(TYPE_SYNCHRO)
end

--cannot be targeted
function c8059.cntgvl(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

--act limit
function c8059.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c8059.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

--send to deck / COST
function c8059.tdcofilter(c)
	return c:IsSetCard(0x2135) and not c:IsType(TYPE_SYNCHRO) and c:IsAbleToDeckAsCost()
end
function c8059.tdco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8059.tdcofilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c8059.tdcofilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

--send to deck / TARGET
function c8059.tdtgfilter(c)
	return c:IsFaceup()	and c:IsAbleToDeck()
end
function c8059.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c8059.tdtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8059.tdtgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c8059.tdtgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c8059.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end