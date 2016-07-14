--ahyakuro: 2

function c8101.initial_effect(c)
	
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8101,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,8036)
	e1:SetTarget(c8101.rhtg)
	e1:SetOperation(c8101.rhop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	
	--cannot sspm from exdeck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(8101,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,8035)
	e4:SetCondition(c8101.dscn)
	e4:SetCost(c8101.dsco)
	e4:SetOperation(c8101.dsop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
	
end

--return to hand
function c8101.rhtgfilter(c)
	return c:IsSetCard(0x2135) and c:IsAbleToHand()
		and not ( c:IsType(TYPE_PENDULUM) or c:IsCode(8101) )
end
function c8101.rhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8101.rhtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8101.rhtgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8101.rhtgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c8101.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsType(TYPE_MONSTER)
			and not (tc:IsType(TYPE_FUSION) or tc:IsType(TYPE_RITUAL) or tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_XYZ))
			and Duel.SelectYesNo(tp,aux.Stringid(8101,1)) then
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
					Duel.ShuffleHand(tp)
		end
	end
end

--destroy
function c8101.dscnfilter(c,tp)
	return c:IsSetCard(0x2135)
		and c:GetPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_GRAVE)
		and not c:IsType(TYPE_TOKEN)
end
function c8101.dscn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c8101.dscnfilter,1,nil,tp)
end

function c8101.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c8101.dsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c8101.optg)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c8101.optg(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_PENDULUM)
end
