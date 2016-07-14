--hyotan: sokei

function c8098.initial_effect(c)

	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8098+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8098.drco)
	e1:SetTarget(c8098.drtg)
	e1:SetOperation(c8098.drop)
	c:RegisterEffect(e1)
	
	--ATK / DEF update
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8098,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c8098.adco)
	e2:SetTarget(c8098.adtg)
	e2:SetOperation(c8098.adop)
	c:RegisterEffect(e2)
	
end

--draw
function c8098.drcofilter(c)
	return c:IsSetCard(0x2137) and c:IsDestructable()
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS))
end
function c8098.drco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8098.drcofilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c8098.drcofilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
end

function c8098.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function c8098.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--ATK / DEF update
function c8098.adco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c8098.adtgfilter(c)
	return c:IsSetCard(0x2137)
		and c:IsFaceup()
		and c:IsType(TYPE_MONSTER)
end
function c8098.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c8098.adtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8098.adtgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c8098.adtgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c8098.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e2)
	end
end
