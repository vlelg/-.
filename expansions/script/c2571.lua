--홍마관의 메이드 - 이자요이 사쿠야

function c2571.initial_effect(c)

 c:SetUniqueOnField(1,0,2571)

  --special summon

  local e1=Effect.CreateEffect(c)

  e1:SetType(EFFECT_TYPE_FIELD)

  e1:SetCode(EFFECT_SPSUMMON_PROC)

 e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)

  e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)

 e1:SetTargetRange(POS_FACEUP_ATTACK,0)

  e1:SetCondition(c2571.spcon)

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
	e1:SetValue(c2571.valcon)
	c:RegisterEffect(e1)

  --effect gain

  local e4=Effect.CreateEffect(c)

  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)

  e4:SetCode(EVENT_BE_MATERIAL)

 e4:SetCondition(c2571.efcon)

  e4:SetOperation(c2571.efop)

  c:RegisterEffect(e4)

--xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(c2571.xyzlimit)
	c:RegisterEffect(e2)

end
function c2571.valcon(e,re,r,rp)
	return e:GetHandler():IsAttackPos() and bit.band(r,REASON_BATTLE)~=0
end
function c2571.spcon(e,c)

  if c==nil then return true end

  return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0

  and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0

end

function c2571.filter(c)

  return not c:IsStatus(STATUS_LEAVE_CONFIRMED)

end

function c2571.efcon(e,tp,eg,ep,ev,re,r,rp)

 return r==REASON_XYZ

end

function c2571.efop(e,tp,eg,ep,ev,re,r,rp)

 Duel.Hint(HINT_CARD,0,2571)

 local c=e:GetHandler()

 local rc=c:GetReasonCard()

 local e5=Effect.CreateEffect(rc)

 e5:SetDescription(aux.Stringid(2571,1))

 e5:SetCategory(CATEGORY_DESTROY)

 e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

 e5:SetProperty(EFFECT_FLAG_CARD_TARGET)

 e5:SetCode(EVENT_SPSUMMON_SUCCESS)

 e5:SetCondition(c2571.descon)

 e5:SetTarget(c2571.destg)

 e5:SetOperation(c2571.desop)

 e5:SetReset(RESET_EVENT+0x1fe0000)

 rc:RegisterEffect(e5,true)

 if not rc:IsType(TYPE_EFFECT) then

  local e6=Effect.CreateEffect(c)

  e6:SetType(EFFECT_TYPE_SINGLE)

  e6:SetCode(EFFECT_CHANGE_TYPE)

  e6:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)

  e6:SetReset(RESET_EVENT+0x1fe0000)

  rc:RegisterEffect(e6)

 end

end

function c2571.descon(e,tp,eg,ep,ev,re,r,rp)

 return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ

end

function c2571.desfilter(c)

 return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)

end

function c2571.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)

 if chkc then return chkc:IsOnField() and c2571.desfilter(chkc) and chkc~=e:GetHandler() end

 if chk==0 then return Duel.IsExistingTarget(c2571.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end

 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)

 local g=Duel.SelectTarget(tp,c2571.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())

 Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)

end

function c2571.desop(e,tp,eg,ep,ev,re,r,rp)

 local tc=Duel.GetFirstTarget()

 if tc:IsRelateToEffect(e) then

  Duel.Destroy(tc,REASON_EFFECT)

 end
end
function c2571.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x770)
end