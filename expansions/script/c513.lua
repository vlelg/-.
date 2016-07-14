--천년빙하
function c513.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c513.target)
	e1:SetCost(c513.cost)
	e1:SetOperation(c513.operation)
	c:RegisterEffect(e1)
	--attack res
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c513.target2)
	c:RegisterEffect(e3)
end
function c513.target2(e,c)
	return c:IsStatus(STATUS_SUMMON_TURN)
end

function c513.costfilter(c)
	return c:IsCode(505) and c:IsDiscardable()
end
function c513.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c513.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c513.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end

function c513.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_SZONE,LOCATION_SZONE,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_SZONE,LOCATION_SZONE,3,3,e:GetHandler())
	Duel.SetChainLimit(aux.FALSE)
end
function c513.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) then
			c:SetCardTarget(tc)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCondition(c513.rcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c513.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
