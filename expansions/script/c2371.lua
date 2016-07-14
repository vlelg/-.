--¿µÈ¥ Á¶À²(¼Ò¿ï Æ©´×)-¡¸°³È­¸¦ ÁØºñÇÏ´Â ²É¡¹
function c2371.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c2371.cost)
	e1:SetTarget(c2371.target)
	e1:SetOperation(c2371.operation)
	c:RegisterEffect(e1)

end
function c2371.cfilter(c)
	return c:IsSetCard(0x268) and c:IsType(TYPE_MONSTER) and 
c:IsAbleToRemoveAsCost()
end
function c2371.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c2371.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c2371.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c2371.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x268) and c:IsLevelAbove(1)
end
function c2371.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c2371.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2371.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c2371.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(2371,0))
	end
	e:SetLabel(op)
end
function c2371.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1) end
		tc:RegisterEffect(e1)
	end
end
