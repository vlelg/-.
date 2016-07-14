--MMJ : Ruisui no Denrei

function c8066.initial_effect(c)
	c:EnableReviveLimit()
	
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c8066.alvl)
	e1:SetCondition(c8066.alcon)
	c:RegisterEffect(e1)
	
	--ATK update
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8066,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c8066.atuco)
	e2:SetOperation(c8066.atuop)
	c:RegisterEffect(e2)
	
	--sendto hand + damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8066,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c8066.thco)
	e3:SetTarget(c8066.thtg)
	e3:SetOperation(c8066.thop)
	c:RegisterEffect(e3)
end

--act limit (e1)
function c8066.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c8066.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end


--ATK update
function c8066.atucofilter(c)
	return c:IsSetCard(0x2135) and c:IsAbleToGraveAsCost()
end
function c8066.atuco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8066.atucofilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c8066.atucofilter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SendtoGrave(cg,POS_FACEUP,REASON_COST)
	e:SetLabel(cg:GetCount())
end

function c8066.atuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(count*500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end


--sendto hand + damage
function c8066.thcofilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsReleasable()
end
function c8066.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c8066.thcofilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c8066.thcofilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c8066.thtgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(8066)
end
function c8066.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c8066.thtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8066.thtgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8066.thtgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end

function c8066.thfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c8066.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,1,REASON_EFFECT)
		local ct1=g:FilterCount(c8066.thfilter,nil,tp)
		local ct2=g:FilterCount(c8066.thfilter,nil,1-tp)
		Duel.Damage(tp,ct1*1000,REASON_EFFECT)
		Duel.Damage(1-tp,ct2*1000,REASON_EFFECT)
	end
end
