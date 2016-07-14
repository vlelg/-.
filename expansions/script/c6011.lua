--Number Ci1000: Numerronius Numerronia
function c6011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,13),5)
	c:EnableReviveLimit()
	
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c6011.indes)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c6011.spcon)
	e2:SetTarget(c6011.sptg)
	e2:SetOperation(c6011.spop)
	c:RegisterEffect(e2)
	
	---Indestructible
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
	--Cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e4)
	
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetTarget(c6011.atlimit)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	
	--disable attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(0,LOCATION_MZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCost(c6011.atkcost)
	e6:SetOperation(c6011.naop)
	c:RegisterEffect(e6)
	
	--Win the duel
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(6011,1))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c6011.discon)
	e7:SetOperation(c6011.disop)
	c:RegisterEffect(e7)
	
end
c6011.xyz_number=1000


---Cannot be destroye except by Numbers
function c6011.indes(e,c)
	return not c:IsSetCard(0x48)
end

---Sp from Extra Deck
function c6011.cfilter(c,tp,x)
	return c:IsCode(6010) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		 and c:IsReason(REASON_DESTROY)		 
end

function c6011.filter(c,cat)
	return  c:IsCode(6010)
end

function c6011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c6011.cfilter,1,nil,tp)
end
function c6011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local g1=Duel.SelectTarget(tp,c6011.filter,tp,LOCATION_GRAVE,0,1,1,nil,6010)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,1,0,0)
	
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()~=1 then return end
	
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		Duel.Overlay(c,mg)
	end
	end
---Cannot Attack Other Monsters
function c6011.atlimit(e,c)
	return c~=e:GetHandler()
end

---Negate Atak
function c6011.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c6011.natg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetAttacker():IsOnField() and Duel.GetAttacker():IsCanBeEffectTarget(e) end
	local rec=Duel.GetAttacker():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end

function c6011.naop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.NegateAttack() then
		Duel.Recover(tp,a:GetAttack(),REASON_EFFECT)
	end
end
-------Win the duel
function c6011.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and not Duel.CheckAttackActivity(tp)
end

function c6011.disop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_NUMERRONIUS_NUMERRONIA = 0x32
	Duel.Win(tp,WIN_REASON_NUMERRONIUS_NUMERRONIA)
end
