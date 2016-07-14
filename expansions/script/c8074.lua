--MMJ : Tomare!

function c8074.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,8074)
	e1:SetCondition(c8074.actcn)
	e1:SetTarget(c8074.acttg)
	e1:SetCost(c8074.actco)
	e1:SetOperation(c8074.actop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c8074.hdcn)
	c:RegisterEffect(e2)

end

--Activate
function c8074.hdcn(e)
	return Duel.GetMatchingGroupCount(c8074.actcnfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)>=3
end
function c8074.actcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2135)
end

function c8074.actcn(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) 
		and Duel.IsChainNegatable(ev)
end

function c8074.actcofilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2135) and c:IsAbleToRemoveAsCost()
		and not c:IsStatus(STATUS_BATTLE_DESTROY)
end
function c8074.actco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8074.actcofilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8074.actcofilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8074.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c8074.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
