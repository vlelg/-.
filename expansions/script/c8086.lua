--soboku: 흑렵덩굴

function c8086.initial_effect(c)

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
	e2:SetDescription(aux.Stringid(8086,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c8086.thtg)
	e2:SetOperation(c8086.thop)
	c:RegisterEffect(e2)
	
	--destroy + damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8086,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c8086.ddco)
	e3:SetTarget(c8086.ddtg)
	e3:SetOperation(c8086.ddop)
	c:RegisterEffect(e3)
	
end

--salvage
function c8086.thtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2136) and c:IsAbleToHand()
		and c:IsType(TYPE_SPELL)
end

function c8086.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c8086.thtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8086.thtgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8086.thtgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c8086.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--destroy
function c8086.ddcofilter(c)
	return c:IsSetCard(0x2136) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c8086.ddco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8086.ddcofilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8086.ddcofilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8086.ddtgfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c8086.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) 
		and c8086.ddtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8086.ddtgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c8086.ddtgfilter,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
	Duel.SetChainLimit(c8086.chlm(g:GetFirst()))
end
function c8086.chlm(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end

function c8086.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,8086)
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
