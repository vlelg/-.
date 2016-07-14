--MMJ ST2
function c8058.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x2135),1)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c8058.rptg)
	e1:SetValue(c8058.rpvl)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	--double attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8058,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c8058.dacn)
	e2:SetCost(c8058.daco)
	e2:SetTarget(c8058.datg)
	e2:SetOperation(c8058.daop)
	c:RegisterEffect(e2)
end

--destroy replace
function c8058.rpfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and (c:IsSetCard(0x2135)) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetFlagEffect(8058)==0
end
function c8058.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c8058.rpfilter,1,nil,tp) end
	local g=eg:Filter(c8058.rpfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(8058,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(8058,1))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end

function c8058.rpvl(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end

--double attack
function c8058.dafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2135) and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
function c8058.dacn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end

function c8058.dacofilter(c)
	return c:IsSetCard(0x2135) and c:IsAbleToDeckAsCost()
end
function c8058.daco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8058.dacofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c8058.dacofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c8058.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c8058.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8058.dafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c8058.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c8058.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end