--soboku: 톱닢

function c8087.initial_effect(c)

	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsType,TYPE_FUSION,Card.IsFusionSetCard,0x2136),2,false)
	
	--only f.summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c8087.cntgvl)
	c:RegisterEffect(e2)
	
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8087,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c8087.thtg)
	e3:SetOperation(c8087.thop)
	c:RegisterEffect(e3)

	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(8087,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c8087.rmco)
	e4:SetTarget(c8087.rmtg)
	e4:SetOperation(c8087.rmop)
	c:RegisterEffect(e4)
	
end

--fusion summon
function c8087.matfilter (c)
	return c:IsFusionSetCard(0x2136) and c:IsType(TYPE_FUSION)
end

--cannot be targeted
function c8087.cntgvl(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

--salvage
function c8087.thtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2136) and c:IsAbleToHand()
		and c:IsType(TYPE_SPELL)
end

function c8087.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c8087.thtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8087.thtgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8087.thtgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end

function c8087.psfilter(c)
	return c:IsFaceup()
end
function c8087.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		
		local tg=Duel.GetMatchingGroup(c8087.psfilter,tp,0,LOCATION_MZONE,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(8087,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg2=tg:Select(tp,1,5,nil)
			Duel.ChangePosition(sg2,POS_FACEDOWN_DEFENCE)
		end
	end
end

--remove
function c8087.rmcofilter(c)
	return c:IsSetCard(0x2136) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c8087.rmco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8087.rmcofilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8087.rmcofilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8087.rmtgfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c8087.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c8087.rmtgfilter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*600)
end

function c8087.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8087.rmtgfilter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()==0 then return end
	Duel.Remove(g,nil,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	Duel.Damage(1-tp,ct*600,REASON_EFFECT)
end
