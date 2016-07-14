--È«¸¶°üÀÇ µÎ³ú - ÆÄÃò¸® ³ë¿ì¸´Áö
function c2574.initial_effect(c)

 c:SetUniqueOnField(1,0,2574)
--xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(c2574.xyzlimit)
	c:RegisterEffect(e2)
  --special summon

  local e1=Effect.CreateEffect(c)

  e1:SetType(EFFECT_TYPE_FIELD)

  e1:SetCode(EFFECT_SPSUMMON_PROC)

 e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)

  e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)

 e1:SetTargetRange(POS_FACEUP_ATTACK,0)

  e1:SetCondition(c2574.spcon)

 c:RegisterEffect(e1)

 --position

 local e2=Effect.CreateEffect(c)

 e2:SetType(EFFECT_TYPE_SINGLE)

 e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)

 e2:SetRange(LOCATION_MZONE)

 e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)

  c:RegisterEffect(e2)

  --battle indestructable

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c2574.valcon)
	c:RegisterEffect(e1)
  --effect gain

  local e4=Effect.CreateEffect(c)

  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)

  e4:SetCode(EVENT_BE_MATERIAL)

 e4:SetCondition(c2574.efcon)

  e4:SetOperation(c2574.efop)

  c:RegisterEffect(e4)

end
function c2574.valcon(e,re,r,rp)
	return e:GetHandler():IsAttackPos() and bit.band(r,REASON_BATTLE)~=0
end
function c2574.spcon(e,c)

  if c==nil then return true end

  return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0

  and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0

end

function c2574.filter(c)

  return not c:IsStatus(STATUS_LEAVE_CONFIRMED)

end

function c2574.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c2574.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(2574,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EVENT_BATTLE_DAMAGE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c2574.drcon)
	e1:SetTarget(c2574.drtg)
	e1:SetOperation(c2574.drop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
	function c2574.filter(c)
	return c:IsSetCard(0x770) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c2574.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c2574.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2574.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2574.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2574.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c2574.spfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c2574.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x770)
end