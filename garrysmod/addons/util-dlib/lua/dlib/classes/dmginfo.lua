local damageTypes = {
  {
    DMG_CRUSH,
    'Crush'
  },
  {
    DMG_BULLET,
    'Bullet'
  },
  {
    DMG_SLASH,
    'Slash'
  },
  {
    DMG_SLASH,
    'Slashing'
  },
  {
    DMG_BURN,
    'Burn'
  },
  {
    DMG_BURN,
    'Fire'
  },
  {
    DMG_BURN,
    'Flame'
  },
  {
    DMG_VEHICLE,
    'Vehicle'
  },
  {
    DMG_FALL,
    'Fall'
  },
  {
    DMG_BLAST,
    'Blast'
  },
  {
    DMG_CLUB,
    'Club'
  },
  {
    DMG_SHOCK,
    'Shock'
  },
  {
    DMG_SONIC,
    'Sonic'
  },
  {
    DMG_ENERGYBEAM,
    'EnergyBeam'
  },
  {
    DMG_ENERGYBEAM,
    'Laser'
  },
  {
    DMG_DROWN,
    'Drown'
  },
  {
    DMG_PARALYZE,
    'Paralyze'
  },
  {
    DMG_NERVEGAS,
    'Gaseous'
  },
  {
    DMG_NERVEGAS,
    'NergeGas'
  },
  {
    DMG_NERVEGAS,
    'Gas'
  },
  {
    DMG_POISON,
    'Poision'
  },
  {
    DMG_ACID,
    'Acid'
  },
  {
    DMG_AIRBOAT,
    'Airboat'
  },
  {
    DMG_BUCKSHOT,
    'Buckshot'
  },
  {
    DMG_DIRECT,
    'Direct'
  },
  {
    DMG_DISSOLVE,
    'Dissolve'
  },
  {
    DMG_DROWNRECOVER,
    'DrownRecover'
  },
  {
    DMG_PHYSGUN,
    'Physgun'
  },
  {
    DMG_PLASMA,
    'Plasma'
  },
  {
    DMG_RADIATION,
    'Radiation'
  },
  {
    DMG_SLOWBURN,
    'Slowburn'
  }
}
do
  local _class_0
  local _base_0 = {
    TypesArray = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      for _index_0 = 1, #damageTypes do
        local _des_0 = damageTypes[_index_0]
        local dtype, dname
        dtype, dname = _des_0[1], _des_0[2]
        if self:IsDamageType(dtype) then
          _accum_0[_len_0] = dtype
          _len_0 = _len_0 + 1
        end
      end
      return _accum_0
    end,
    RecordInflictor = function(self)
      if self.inflictor ~= self.attacker or not self.attacker.GetActiveWeapon then
        self.recordedInflictor = self.inflictor
        return 
      end
      local weapon = self.attacker:GetActiveWeapon()
      if not IsValid(weapon) then
        self.recordedInflictor = self.inflictor
        return 
      end
      self.recordedInflictor = weapon
    end,
    AddDamage = function(self, damageNum)
      if damageNum == nil then
        damageNum = 0
      end
      self.damage = math.clamp(self.damage + damageNum, 0, 0x7FFFFFFF)
    end,
    SubtractDamage = function(self, damageNum)
      if damageNum == nil then
        damageNum = 0
      end
      self.damage = math.clamp(self.damage - damageNum, 0, 0x7FFFFFFF)
    end,
    GetDamageType = function(self)
      return self.damageType
    end,
    GetAttacker = function(self)
      return self.attacker
    end,
    GetInflictor = function(self)
      return self.inflictor
    end,
    GetRecordedInflictor = function(self)
      return self.recordedInflictor
    end,
    GetBaseDamage = function(self)
      return self.damage
    end,
    GetAmmoType = function(self)
      return self.ammoType
    end,
    GetDamage = function(self)
      return self.damage
    end,
    GetDamageBonus = function(self)
      return self.damageBonus
    end,
    GetDamageCustom = function(self)
      return self.damageCustomFlags
    end,
    GetDamageForce = function(self)
      return self.damageForce
    end,
    GetDamagePosition = function(self)
      return self.damagePosition
    end,
    GetReportedPosition = function(self)
      return self.reportedPosition
    end,
    GetDamageForce = function(self)
      return self.damageForce
    end,
    GetDamageType = function(self)
      return self.damageType
    end,
    GetMaxDamage = function(self)
      return self.maxDamage
    end,
    GetBaseDamage = function(self)
      return self.baseDamage
    end,
    IsDamageType = function(self, dtype)
      return self.damageType:band(dtype) == dtype
    end,
    IsBulletDamage = function(self)
      return self:IsDamageType(DMG_BULLET)
    end,
    IsExplosionDamage = function(self)
      return self:IsDamageType(DMG_BLAST)
    end,
    IsFallDamage = function(self)
      return self:IsDamageType(DMG_FALL)
    end,
    ScaleDamage = function(self, scaleBy)
      self.damage = math.clamp(self.damage * scaleBy, 0, 0x7FFFFFFF)
    end,
    SetAmmoType = function(self, ammotype)
      self.ammoType = ammotype
    end,
    SetAttacker = function(self, attacker)
      self.attacker = assert(isentity(attacker) and attacker, 'Invalid attacker')
    end,
    SetInflictor = function(self, attacker)
      self.inflictor = assert(isentity(attacker) and attacker, 'Invalid inflictor')
    end,
    SetRecordedInflictor = function(self, attacker)
      self.recordedInflictor = assert(isentity(attacker) and attacker, 'Invalid recorded inflictor')
    end,
    SetDamage = function(self, dmg)
      self.damage = math.clamp(dmg, 0, 0x7FFFFFFF)
    end,
    SetDamageBonus = function(self, dmg)
      self.damageBonus = math.clamp(dmg, 0, 0x7FFFFFFF)
    end,
    SetMaxDamage = function(self, dmg)
      self.maxDamage = math.clamp(dmg, 0, 0x7FFFFFFF)
    end,
    SetDamageCustom = function(self, dmg)
      self.damageCustomFlags = dmg
    end,
    SetDamageType = function(self, dmg)
      self.damageType = dmg
    end,
    SetDamagePosition = function(self, pos)
      self.damagePosition = pos
    end,
    SetReportedPosition = function(self, pos)
      self.reportedPosition = pos
    end,
    SetDamageForce = function(self, force)
      self.damageForce = force
    end,
    SetBaseDamage = function(self, damage)
      self.baseDamage = damage
    end,
    Copy = function(self)
      return DLib.LTakeDamageInfo(self)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, copyfrom)
      self.damage = 0
      self.baseDamage = 0
      self.maxDamage = 0
      self.ammoType = 0
      self.damageBonus = 0
      self.damageCustomFlags = 0
      self.damageForce = Vector()
      self.reportedPosition = Vector()
      self.damagePosition = Vector()
      self.damageType = DMG_GENERIC
      self.attacker = NULL
      self.inflictor = NULL
      self.recordedInflictor = NULL
      if copyfrom then
        do
          local _with_0 = copyfrom
          self:SetAmmoType(_with_0:GetAmmoType())
          self:SetAttacker(_with_0:GetAttacker())
          self:SetBaseDamage(_with_0:GetBaseDamage())
          self:SetDamage(_with_0:GetDamage())
          self:SetDamageBonus(_with_0:GetDamageBonus())
          self:SetDamageCustom(_with_0:GetDamageCustom())
          self:SetDamageForce(_with_0:GetDamageForce())
          self:SetDamagePosition(_with_0:GetDamagePosition())
          self:SetDamageType(_with_0:GetDamageType())
          self:SetInflictor(_with_0:GetInflictor())
          self:SetMaxDamage(_with_0:GetMaxDamage())
          self:SetReportedPosition(_with_0:GetReportedPosition())
          return _with_0
        end
      end
    end,
    __base = _base_0,
    __name = "LTakeDamageInfo"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  for _index_0 = 1, #damageTypes do
    local _des_0 = damageTypes[_index_0]
    local dtype, dname
    dtype, dname = _des_0[1], _des_0[2]
    self.__base['Is' .. dname .. 'Damage'] = function(self)
      return self:IsDamageType(dtype)
    end
  end
  self.__base.MetaName = 'LTakeDamageInfo'
  DLib.LTakeDamageInfo = _class_0
  return _class_0
end
