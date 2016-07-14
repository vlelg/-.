--MMJ 5
function c8064.initial_effect(c)

	c:EnableReviveLimit()
	
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,8064)
	e2:SetCondition(c8064.spcn)
	e2:SetOperation(c8064.spop)
	c:RegisterEffect(e2)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8064,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c8064.dsco)
	e3:SetTarget(c8064.dstg)
	e3:SetOperation(c8064.dsop)
	c:RegisterEffect(e3)
end

--special summon
function c8064.spfilter(c)
	return c:IsSetCard(0x2135) and not c:IsCode(8064) and c:IsAbleToRemoveAsCost()
end
function c8064.spcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8064.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c8064.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8064.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--destroy
function c8064.dscofilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsReleasable()
end
function c8064.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c8064.dscofilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c8064.dscofilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c8064.dstgfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c8064.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField(1-tp) and c8064.dstgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8064.dstgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c8064.dstgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c8064.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)
	end
end