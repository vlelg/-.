--Numeron Rewriting Magic
function c6012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c6012.condition)
	e1:SetTarget(c6012.target)
	e1:SetOperation(c6012.activate)
	c:RegisterEffect(e1)
end
function c6012.cfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c6012.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsType(TYPE_SPELL) and rp~=tp and Duel.IsChainNegatable(ev)
	and not Duel.IsExistingMatchingCard(c6012.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
end
function c6012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	end
end
function c6012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,g1)
	
	function c6012.filter(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_TRAP) and c:IsSSetable()
    end
	   
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c6012.filter,1-tp,LOCATION_DECK,0,1,nil)
    end	
  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ACTIVATE)
	local g=Duel.SelectMatchingCard(tp,c6012.filter,1-tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(1-tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
	
end