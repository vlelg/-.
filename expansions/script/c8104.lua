--ookami no tasogare

function c8104.initial_effect(c)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,8104+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8104.co)
	e1:SetTarget(c8104.tg)
	e1:SetOperation(c8104.op)
	c:RegisterEffect(e1)

end

--Activate
function c8104.cofilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() 
		and ( c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR) or c:IsRace(RACE_WINDBEAST) )
		and Duel.IsExistingMatchingCard(c8104.tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c8104.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8104.cofilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c8104.cofilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(g:GetFirst())
end

function c8104.tgfilter(c,e,tp,dc,code)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsCode(dc:GetCode())
		and c:IsRace(dc:GetRace()) 
		and c:IsAttribute(dc:GetAttribute())
		and c:GetLevel()==dc:GetLevel()
end
function c8104.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c8104.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c8104.tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabelObject())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
