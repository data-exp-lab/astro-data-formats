meta:
  id: gadget_format1
  endian: le
seq:
  - id: gadget_header
    type: header
  - id: magic1
    type: u4
  - id: coordinates
    type: vector_field(_index)
    repeat: expr
    repeat-expr: 6
  - id: magic2
    type: u4
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
  scalar_field:
    params:
      - id: index
        type: u1
    seq:
      - id: field
        type: f4
        repeat: expr
        repeat-expr: _root.gadget_header.npart[index]
  vector_field:
    params:
      - id: index
        type: u1
    seq:
      #- id: recsize_0
      #  type: u4
      #  if: _root.npart[index] > 0
      - id: field
        type: f4
        repeat: expr
        repeat-expr: _root.gadget_header.npart[index] * 3
      #- id: recsize_1
      #  type: u4
      #  if: _root.npart[index] > 0
#                   ('FlagCooling', 1, 'i'),
#                   ('NumFiles', 1, 'i'),
#                   ('BoxSize', 1, 'd'),
#                   ('Omega0', 1, 'd'),
#                   ('OmegaLambda', 1, 'd'),
#                   ('HubbleParam', 1, 'd'),
#                   ('FlagAge', 1, 'i'),
#                   ('FlagMetals', 1, 'i'),
#                   ('NallHW', 6, 'i'),
#                   ('unused', 16, 'i')),
