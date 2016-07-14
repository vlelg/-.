--Numeron Direct
function c6007.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c6007.condition)
	e1:SetTarget(c6007.tg)
	e1:SetOperation(c6007.op)
	c:RegisterEffect(e1)
end

function c6007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetEnvironment()==6005
end

function c6007.filter(c,e,tp)
	return c:IsAttackBelow(1000) and c:IsSetCard(667) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c6007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=4
		and Duel.IsExistingTarget(c6007.filter,tp,LOCATION_EXTRA,0,4,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6007.filter,tp,LOCATION_EXTRA,0,4,4,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end

function c6007.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() then return end
	if sg:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(6007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end 
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(sg) 
		e1:SetOperation(c6007.rmop)
		Duel.RegisterEffect(e1,tp)
	end	
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE) 	
end

function c6007.rmfilter(c)
	return c:GetFlagEffect(6007)>0
end

function c6007.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local tg=sg:Filter(c6007.rmfilter,nil)
	sg:DeleteGroup()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
