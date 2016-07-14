--홍마관의 문지기 - 홍 메이린
function c2573.initial_effect(c)

 c:SetUniqueOnField(1,0,2573)

  --special summon

  local e1=Effect.CreateEffect(c)

  e1:SetType(EFFECT_TYPE_FIELD)

  e1:SetCode(EFFECT_SPSUMMON_PROC)

 e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)

  e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)

 e1:SetTargetRange(POS_FACEUP_ATTACK,0)

  e1:SetCondition(c2573.spcon)

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
	e1:SetValue(c2573.valcon)
	c:RegisterEffect(e1)
  --effect gain

  local e4=Effect.CreateEffect(c)

  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)

  e4:SetCode(EVENT_BE_MATERIAL)

 e4:SetCondition(c2573.efcon)

  e4:SetOperation(c2573.efop)

  c:RegisterEffect(e4)

end
function c2573.valcon(e,re,r,rp)
	return e:GetHandler():IsAttackPos() and bit.band(r,REASON_BATTLE)~=0
end
function c2573.spcon(e,c)

  if c==nil then return true end

  return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0

  and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0

end

function c2573.filter(c)

  return not c:IsStatus(STATUS_LEAVE_CONFIRMED)

end

function c2573.efcon(e,tp,eg,ep,ev,re,r,rp)

 return r==REASON_XYZ

end
function c2573.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x770)
end
function c2573.efop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e5=Effect.CreateEffect(rc)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e5)

 if not rc:IsType(TYPE_EFFECT) then

  local e6=Effect.CreateEffect(c)

  e6:SetType(EFFECT_TYPE_SINGLE)

  e6:SetCode(EFFECT_CHANGE_TYPE)

  e6:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)

  e6:SetReset(RESET_EVENT+0x1fe0000)

  rc:RegisterEffect(e6)

 end

end
function c2573.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x770)
end
function c2573.descon(e,tp,eg,ep,ev,re,r,rp)

 return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ

end

function c2573.desfilter(c)

 return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)

end

function c2573.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)

 if chkc then return chkc:IsOnField() and c2573.desfilter(chkc) and chkc~=e:GetHandler() end

 if chk==0 then return Duel.IsExistingTarget(c2573.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end

 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)

 local g=Duel.SelectTarget(tp,c2573.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())

 Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)

end

function c2573.desop(e,tp,eg,ep,ev,re,r,rp)

 local tc=Duel.GetFirstTarget()

 if tc:IsRelateToEffect(e) then

  Duel.Destroy(tc,REASON_EFFECT)

 end

end