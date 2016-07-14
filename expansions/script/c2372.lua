--��ȥ���(�ҿ� ����Ƽ)-���õ����� ���� ���� �͡�
function c2372.initial_effect(c)
   --Activate
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_FREE_CHAIN)
   c:RegisterEffect(e1)
   --REMOVE
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(2372,0))
   e2:SetCategory(CATEGORY_REMOVE)
   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
   e2:SetRange(LOCATION_SZONE)
   e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
   e2:SetCode(EVENT_DESTROYED)
   e2:SetCountLimit(1,2372)
   e2:SetCondition(c2372.tgcon)
   e2:SetTarget(c2372.tgtg)
   e2:SetOperation(c2372.tgop)
   c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2372,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c2372.thtg)
	e3:SetOperation(c2372.thop)
	c:RegisterEffect(e3)
	--atkdown
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c2372.atkcon)
	e4:SetValue(c2372.atkval)
	c:RegisterEffect(e4)
end
function c2372.cfilter(c,tp)
   return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c2372.tgcon(e,tp,eg,ep,ev,re,r,rp)
   return eg:IsExists(c2372.cfilter,1,nil,tp)
end
function c2372.filter(c)
   return c:IsSetCard(0x268) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c2372.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsRelateToEffect(e)
	  and Duel.IsExistingMatchingCard(c2372.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c2372.tgop(e,tp,eg,ep,ev,re,r,rp)
   if not e:GetHandler():IsRelateToEffect(e) then return end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
   local g=Duel.SelectMatchingCard(tp,c2372.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
   end
end
function c2372.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x268)
end
function c2372.thfilter(c)
	return c:IsSetCard(0x268) and c:IsAbleToHand()
end
function c2372.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c2372.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2372.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(c2372.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c2372.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2372.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c2372.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c2372.atkcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c2372.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x268)
end
function c2372.atkval(e,c)
	return Duel.GetMatchingGroupCount(c2372.atfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)*-100
end
