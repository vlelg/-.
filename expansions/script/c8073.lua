--MMJ Kamen
function c8073.initial_effect(c)

	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80730001)
	e1:SetTarget(c8073.sptg)
	e1:SetOperation(c8073.spop)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80730002)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c8073.thco)
	e2:SetTarget(c8073.thtg)
	e2:SetOperation(c8073.thop)
	c:RegisterEffect(e2)
	
end

--ritual summon
function c8073.exsptgfilter(c)
	return c:IsSetCard(0x2135) and c:IsAbleToGrave()
end
function c8073.sptgfilter(c,e,tp,m)
	if not c:IsSetCard(0x2135) or bit.band(c:GetType(),0x81)~=0x81
	or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumGreater(c8073.mf,c:GetLevel(),c)
end
function c8073.mf(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetRitualLevel(rc)
	end
end
function c8073.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_BEASTWARRIOR)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			local sg=Duel.GetMatchingGroup(c8073.exsptgfilter,tp,LOCATION_EXTRA,0,nil)
			mg:Merge(sg)
		end
		return Duel.IsExistingMatchingCard(c8073.sptgfilter,tp,loc,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end

function c8073.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_BEASTWARRIOR)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		local sg=Duel.GetMatchingGroup(c8073.exsptgfilter,tp,LOCATION_EXTRA,0,nil)
		mg:Merge(sg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	local tg=Duel.SelectMatchingCard(tp,c8073.sptgfilter,tp,loc,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumGreater(tp,c8073.mf,tc:GetLevel(),tc)
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end


--search
function c8073.thcofilter(c)
	return c:IsSetCard(0x2135) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c8073.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c8073.thcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8073.thcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8073.thtgfilter(c)
	return c:IsSetCard(0x2135) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c8073.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8073.thtgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c8073.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8073.thtgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
