--hyotan: sekka

function c8091.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8091,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,8091)
	e1:SetTarget(c8091.sstg)
	e1:SetOperation(c8091.ssop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8091,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,8044)
	e3:SetTarget(c8091.svtg)
	e3:SetOperation(c8091.svop)
	c:RegisterEffect(e3)
	
end

--special summon
function c8091.sstgfilter(c,e,tp)
	return c:IsSetCard(0x2137) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8091.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_SZONE) and chkc:IsControler()
		and c8091.sstgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8091.sstgfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
end

function c8091.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c8091.sstgfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--salvage
function c8091.svtgfilter(c)
	return c:IsSetCard(0x2137) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c8091.svtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8091.svtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8091.svtgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8091.svtgfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c8091.svop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
