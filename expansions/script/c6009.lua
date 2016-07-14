--Numeron Chaos Ritual
function c6009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c6009.condition)
	e1:SetTarget(c6009.target)
	e1:SetOperation(c6009.activate)
	c:RegisterEffect(e1)
	if not c6009.global_check then
		c6009.global_check=true
		c6009[0]=false
		c6009[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c6009.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c6009.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c6009.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pos=tc:GetPosition()
		if  tc:IsCode(6006) and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
			and tc:GetControler()==tc:GetPreviousControler() then
			c6009[tc:GetControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c6009.clear(e,tp,eg,ep,ev,re,r,rp)
	c6009[0]=false
	c6009[1]=false
end
function c6009.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()==12 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6009.filter(c,cat)
	return  c:IsType(TYPE_XYZ) and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsSetCard(667))
end
function c6009.filter2(c,cat)
	return c:IsType(TYPE_SPELL) and c:IsCode(6005)
end
function c6009.condition(e,tp,eg,ep,ev,re,r,rp)
	return c6009[tp] and Duel.GetFlagEffect(tp,6009)==0
end
function c6009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c6009.filter,tp,LOCATION_GRAVE,0,4,nil,0x1073)
		and Duel.IsExistingTarget(c6009.filter2,tp,LOCATION_GRAVE,0,1,nil,6005) 
		and Duel.IsExistingMatchingCard(c6009.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectTarget(tp,c6009.filter,tp,LOCATION_GRAVE,0,4,4,nil,0x1073)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectTarget(tp,c6009.filter2,tp,LOCATION_GRAVE,0,1,1,nil,6005)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c6009.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()~=5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(sc,mg)
	end
end


