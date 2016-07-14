--soboku: 수면관엽

function c8080.initial_effect(c)
	
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2136),2,true)
	
	--only f.summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8080,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c8080.thtg)
	e2:SetOperation(c8080.thop)
	c:RegisterEffect(e2)
	
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8080,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c8080.flco)
	e3:SetTarget(c8080.fltg)
	e3:SetOperation(c8080.flop)
	c:RegisterEffect(e3)
	
end

--salvage
function c8080.thtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2136) and c:IsAbleToHand()
		and c:IsType(TYPE_SPELL)
end

function c8080.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c8080.thtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8080.thtgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8080.thtgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c8080.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--flip
function c8080.flcofilter(c)
	return c:IsSetCard(0x2136) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c8080.flco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8080.flcofilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8080.flcofilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8080.fltgfilter(c)
	return c:IsCanTurnSet()
end
function c8080.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8080.fltgfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c8080.fltgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end

function c8080.flop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8080.fltgfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
	end
end