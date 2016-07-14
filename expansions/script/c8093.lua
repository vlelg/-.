--hyotan: rokka

function c8093.initial_effect(c)
	
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8093,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,8093)
	e2:SetCondition(c8093.spcn)
	c:RegisterEffect(e2)

	--send to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8093,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c8093.tdco)
	e3:SetTarget(c8093.tdtg)
	e3:SetOperation(c8093.tdop)
	c:RegisterEffect(e3)
	
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c8093.indtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	
end

--special summon
function c8093.spcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2137)
		and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS)
end
function c8093.spcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c8093.spcnfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>2
end

--send to deck
function c8093.tdcofilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and not c:IsLocation(LOCATION_FZONE) or c:IsLocation(LOCATION_PZONE)
end
function c8093.tdco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8093.tdcofilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c8093.tdcofilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
end

function c8093.tdtgfilter(c)
	return c:IsAbleToDeck()
end
function c8093.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c8093.tdtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8093.tdtgfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c8093.tdtgfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c8093.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

--indes
function c8093.indtg(e,c)
	return c:IsSetCard(0x2137) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
