--영혼 불협화음(소울 디조넨스) - 죽은 꽃의 시
function c2374.initial_effect(c)
	--counter card
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c2374.condition)
	e1:SetCost(c2374.cost)
	e1:SetTarget(c2374.distg)
	e1:SetOperation(c2374.disop)
	c:RegisterEffect(e1)
end
function c2374.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x268)
end
function c2374.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c2374.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c2374.filter(c)
	return c:IsSetCard(0x268)
end
function c2374.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c2374.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c2374.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c2374.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c2374.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end