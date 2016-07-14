--Number 100: Numeron Dragon
function c6016.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,1),2)
	c:EnableReviveLimit()
	
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c6016.indes)
	c:RegisterEffect(e1)
	
    --Attack to 0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c6016.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)	
	
	--destroy monsters on field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(6016,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c6016.destg)
	e4:SetOperation(c6016.desop)
	c:RegisterEffect(e4)
	
	--attack up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c6016.cost)
	e5:SetOperation(c6016.atkop)
	c:RegisterEffect(e5)
	
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(6016,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c6016.condition)
	e7:SetTarget(c6016.target)
	e7:SetOperation(c6016.operation)
	c:RegisterEffect(e7)
end

c6016.xyz_number=100

function c6016.indes(e,c)
	return not c:IsSetCard(0x48)
end


function c6016.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e2)
	end
end

function c6016.tgfilter(c,id)
	return not c:IsType(TYPE_MONSTER) and c:IsSSetable() and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_EFFECT) and c:GetTurnID()==id
end

function c6016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)	
end
function c6016.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
		
	local h = Duel.GetMatchingGroupCount(c6016.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,Duel.GetTurnCount())
	local h2 = Duel.GetMatchingGroupCount(c6016.tgfilter,1-tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,Duel.GetTurnCount())
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_SET)
    local g1=Duel.SelectMatchingCard(tp,c6016.tgfilter,tp,LOCATION_GRAVE,0,h,h,nil,Duel.GetTurnCount())
    local tc1=g1:GetFirst()
    
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_HINTMSG_SET)
    local g2=Duel.SelectMatchingCard(1-tp,c6016.tgfilter,tp,0,LOCATION_GRAVE,h2,h2,nil,Duel.GetTurnCount())
    local tc2=g2:GetFirst()
    
    Duel.SSet(sp,g1,tp)  
    Duel.SSet(sp2,g2,1-tp)
    
end


function c6016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c6016.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	    
	if c:IsRelateToEffect(e) and c:IsFaceup() then	
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local val=g:GetSum(Card.GetRank)*1000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetHintTiming(TIMING_BATTLE_PHASE,0)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c6016.cfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c6016.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil and at:IsType(TYPE_XYZ)
	and not Duel.IsExistingMatchingCard(c6016.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) 
end
function c6016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c6016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
	end
end
