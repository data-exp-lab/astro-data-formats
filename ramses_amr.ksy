meta:
  id: ramses_amr
  endian: le
  ks-opaque-types: true
seq:
  - id: header
    type: ramses_header

types:
  ramses_header:
    seq:
      - id: ncpu
        type: fortran_record(1, "u4")
      - id: ndim
        type: fortran_record(1, "u4")
      - id: nx
        type: fortran_record(3, "u4")
      - id: nlevelmax
        type: fortran_record(1, "u4")
      - id: ngridmax
        type: fortran_record(1, "u4")
      - id: nboundary
        type: fortran_record(1, "u4")
      - id: ngrid_current
        type: fortran_record(1, "u4")
      - id: boxlen
        type: fortran_record(1, "f8")
      - id: nout
        type: fortran_record(3, "u4")
      - id: tout
        type: fortran_record(nout.value[0], "f8")
      - id: aout
        type: fortran_record(nout.value[0], "f8")
      - id: t
        type: fortran_record(1, "f8")
      - id: dtold
        type: fortran_record(nlevelmax.value[0], "f8")
      - id: dtnew
        type: fortran_record(nlevelmax.value[0], "f8")
      - id: nstep
        type: fortran_record(2, "u4")
      - id: stat
        type: fortran_record(3, "f8")
      - id: cosm
        type: fortran_record(7, "f8")
      - id: timing
        type: fortran_record(5, "f8")
      - id: mass_sph
        type: fortran_record(1, "f8")
      - id: headl
        type: fortran_skip
      - id: taill
        type: fortran_skip
      - id: numbl
        type: fortran_vector("u4")
  fortran_record:
    params:
      - id: num_records
        type: u4
      - id: record_type
        type: str
    seq:
      - id: rec_size1
        type: u4
      - id: value
        type:
          switch-on: record_type
          cases:
            '"u4"': u4
            '"u8"': u8
            '"f4"': f4
            '"f8"': f8
        repeat: expr
        repeat-expr: num_records
      - id: rec_size2
        type: u4
  fortran_vector:
    params:
      - id: record_type
        type: str
    seq:
      - id: rec_size1
        type: u4
      - id: value
        type:
          switch-on: record_type
          cases:
            '"u4"': u4
            '"u8"': u8
            '"f4"': f4
            '"f8"': f8
        size: rec_size1
      - id: rec_size2
        type: u4
  fortran_skip:
    seq:
      - id: rec_size1
        type: u4
      - id: contents
        size: rec_size1
      - id: rec_size2
        type: u4
