--Numeron Rewriting Xyz
function c6013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c6013.condition)
	e1:SetTarget(c6013.target)
	e1:SetOperation(c6013.activate)
	c:RegisterEffect(e1)
end

function c6013.cfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c6013.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:GetFirst():IsType(TYPE_XYZ) and Duel.GetCurrentChain()==0 
	and not Duel.IsExistingMatchingCard(c6013.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
end

function c6013.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c6013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c6013.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg:GetFirst())
	Duel.Destroy(eg,REASON_EFFECT)
	
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,g1)
	
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c6013.filter,tp,LOCATION_DECK,0,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6013.filter,1-tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	    if tc and Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
	end
	end
end
