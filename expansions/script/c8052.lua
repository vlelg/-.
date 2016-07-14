--MMJ2
function c8052.initial_effect(c)
	--special summon 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8052,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,8052)
	e1:SetCondition(c8052.spcon)
	c:RegisterEffect(e1)
	--special summon 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8052,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,8031)
	e2:SetCost(c8052.spcost)
	e2:SetTarget(c8052.sptg)
	e2:SetOperation(c8052.spop)
	c:RegisterEffect(e2)
end
--special summon 1
function c8052.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2135)
end
function c8052.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8052.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--special summon 2
function c8052.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c8052.filter(c,e,tp)
	return c:IsSetCard(0x2135) and not c:IsCode(8052)
		and (c:IsLevelBelow(4) or c:IsRankBelow(4))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c8052.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c8052.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c8052.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end