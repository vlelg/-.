--MMJ REIKENSEI
function c8060.initial_effect(c)

	--summon method
	
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c8060.tfilter,aux.NonTuner(Card.IsSetCard,0x2135),2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	
	--atk / def update
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c8060.atvl)
	c:RegisterEffect(e2)
	
	--cannot be targeted
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c8060.cntgvl)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c8060.cndsvl)
	c:RegisterEffect(e4)
	
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(8060,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(2)
	e5:SetCondition(c8060.ngcn)
	e5:SetCost(c8060.ngco)
	e5:SetTarget(c8060.ngtg)
	e5:SetOperation(c8060.ngop)
	c:RegisterEffect(e5)
end

--synchro summon
function c8060.tfilter(c)
	return c:IsSetCard(0x2135) and c:IsType(TYPE_SYNCHRO)
end

--atk / def update
function c8060.atvl(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0x2135)*100
end

--cannot be targeted
function c8060.cntgvl(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

function c8060.cndsvl(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end

--negate
function c8060.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and Duel.IsChainNegatable(ev)
end

function c8060.ngcofilter(c)
	return c:IsSetCard(0x2135) and not c:IsType(TYPE_SYNCHRO) and c:IsAbleToDeckAsCost()
end
function c8060.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8060.ngcofilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c8060.ngcofilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,3,REASON_COST)
end

function c8060.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
	
function c8060.ngop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end