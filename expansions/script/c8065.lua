--MMJ : Bakuen no Denrei
function c8065.initial_effect(c)

	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c8065.fsmtfilter,2,false)
	
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c8065.spcnlimit)
	c:RegisterEffect(e1)
	
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c8065.srcn)
	e2:SetOperation(c8065.srop)
	c:RegisterEffect(e2)
	
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c8065.alvl)
	e3:SetCondition(c8065.alcon)
	c:RegisterEffect(e3)

	--ATK / DEF update
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(8065,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetCountLimit(1)
	e4:SetCondition(c8065.adcn)
	e4:SetCost(c8065.adco)
	e4:SetTarget(c8065.adtg)
	e4:SetOperation(c8065.adop)
	c:RegisterEffect(e4)
	
	--sendto hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(8065,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c8065.thtg)
	e5:SetOperation(c8065.thop)
	c:RegisterEffect(e5)
	
end

--fusion summon
function c8065.fsmtfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeFusionMaterial()
end


-- special summon condition + rule (e1 + e2)
function c8065.spcnlimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c8065.srcnfilter(c,tp,fc)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_SYNCHRO)
	   and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c8065.srcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
	   and Duel.IsExistingMatchingCard(c8065.srcnfilter,tp,LOCATION_MZONE,0,2,nil,tp,c)
end

function c8065.srop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8065.srcnfilter,tp,LOCATION_MZONE,0,2,2,nil,tp,c)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end


--act limit (e3)
function c8065.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c8065.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end


--ATK / DEF update (e4)
function c8065.adcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end

function c8065.adcofilter(c)
	return c:IsSetCard(0x2135) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not c:IsType(TYPE_XYZ)
end
function c8065.adco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8065.adcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8065.adcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8065.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c8065.adop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local tc1=Duel.GetFirstTarget()
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone(e:GetHandler())
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc1:RegisterEffect(e2)
	end
end



--sendto hand (e5)
function c8065.thfilter(c)
	return c:IsSetCard(0x2135) and c:IsAbleToHand()
end
function c8065.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c8065.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8065.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8065.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c8065.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
