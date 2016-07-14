--MMJ : Set-Tou
function c8070.initial_effect(c)
	
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c8070.reg)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,8045)
	e2:SetCondition(c8070.thcn)
	e2:SetTarget(c8070.thtg)
	e2:SetOperation(c8070.thop)
	c:RegisterEffect(e2)
	
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(aux.nfbdncon)
	e3:SetTarget(c8070.pslimit)
	c:RegisterEffect(e3)
	
	--revive
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(8070,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,8070+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(c8070.rvco)
	e4:SetTarget(c8070.rvtg)
	e4:SetOperation(c8070.rvop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e5)

end

--activate
function c8070.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(8070,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

--search
function c8070.thcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(8070)~=0
end

function c8070.thtgfilter(c)
	return c:IsSetCard(0x2135) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c8070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8070.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c8070.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8070.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


--pendulum summon limit
function c8070.pslimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x2135) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end


--revive
function c8070.rvcofilter(c)
	return c:IsSetCard(0x2135) and c:IsFaceup() and c:IsAbleToRemoveAsCost() and not c:IsCode(8070)
end
function c8070.rvco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8070.rvcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8070.rvcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8070.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function c8070.rvop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
