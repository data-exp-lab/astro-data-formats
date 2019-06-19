meta:
  id: gadget_format1
  endian: le
  ks-opaque-types: true
  imports:
    - array_buffer
seq:
  - id: gadget_header
    type: header
  - id: coordinates
    type: particle_fields('f4', 3)
  - id: velocities
    type: particle_fields('f4', 3)
  - id: particle_ids
    type: particle_fields('u4', 1)
types:
  header:
    seq:
      - id: recsize_0
        type: u4
      - id: npart
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: massarr
        type: f8
        repeat: expr
        repeat-expr: 6
      - id: time
        type: f8
      - id: redshift
        type: f8
      - id: flag_sfr
        type: u4
      - id: flag_feedback
        type: u4
      - id: n_all
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: flag_cooling
        type: u4
      - id: numfiles
        type: u4
      - id: boxsize
        type: f8
      - id: omega0
        type: f8
      - id: omega_lambda
        type: f8
      - id: hubble_param
        type: f8
      - id: flag_age
        type: u4
      - id: flag_metals
        type: u4
      - id: nall_hw
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: unused
        type: u4
        repeat: expr
        repeat-expr: 16
      - id: recsize_1
        type: u4
  particle_fields:
    params:
      - id: field_type
        type: str
      - id: components
        type: u1
    seq:
      - id: magic1
        type: u4
      - id: fields
        type: field(_index, components, field_type)
        repeat: expr
        repeat-expr: 6
      - id: magic2
        type: u4
  field:
    params:
      - id: index
        type: u1
      - id: components
        type: u1
      - id: field_type
        type: str
    seq:
      - id: field
        size: _root.gadget_header.npart[index] * components * 4
        type: array_buffer(field_type)
