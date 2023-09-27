meta:
  id: ramses_amr
  endian: le
  ks-opaque-types: true
seq:
  - id: header
    type: ramses_header
  - id: amr_info
    type: ramses_amr_info
types:
  ramses_amr_info:
    seq:
      - id: level_infos
        type: ramses_amr_level_info
        repeat: expr
        repeat-expr: _root.header.nlevelmax.value[0].as<u4>
  ramses_amr_level_info:
    seq:
      - id: cpu_info
        type: ramses_level_cpu_info
        repeat: expr
        repeat-expr: _root.header.ncpu.value[0].as<u4> + _root.header.nboundary.value[0].as<u4>
  ramses_level_cpu_info:
    # This is where we need to check the number of grids here
    # yt has:
    # if icpu < ncpu:
    #     ng = numbl[ilevel, icpu]
    # else:
    #     ng = ngridbound[icpu - ncpu + nboundary * ilevel]
    # we should split this up and have it accept a parameter
    seq:
      - id: grid_index
        type: fortran_skip
      - id: grid_next
        type: fortran_skip
      - id: grid_prev
        type: fortran_skip
      - id: pos_x
        type: fortran_vector("f8")
      - id: pos_y
        type: fortran_vector("f8")
      - id: pos_z
        type: fortran_vector("f8")
      - id: fields
        type: fortran_skip
        repeat: expr
        repeat-expr: 31
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
        type: fortran_record(nout.value[0].as<u4>, "f8")
      - id: aout
        type: fortran_record(nout.value[0].as<u4>, "f8")
      - id: t
        type: fortran_record(1, "f8")
      - id: dtold
        type: fortran_record(nlevelmax.value[0].as<u4>, "f8")
      - id: dtnew
        type: fortran_record(nlevelmax.value[0].as<u4>, "f8")
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
        type: fortran_vector("u4")
      - id: taill
        type: fortran_vector("u4")
      - id: numbl
        # numbl is of shape [nlevelmax, ncpu+nboundary]
        #type: fortran_vector("u4")
        # This is set up so that the first is of shape nlevelmax and second is
        # ncpu+nboundary.
        type:
          fortran_2d_vector("u4", nlevelmax.value[0].as<u4>)
      - id: unk1
        type: fortran_skip
      - id: ngridbound
        if: nboundary.value[0].as<u4> > 0
        type: fortran_vector("u4")
      - id: free_mem
        type: fortran_record(5, "u4")
      - id: ordering
        type: charstring
      - id: unk2
        type: fortran_skip
        repeat: expr
        repeat-expr: 4
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
      - id: vector
        type: vector_values(record_type)
        size: rec_size1
      - id: rec_size2
        type: u4
  fortran_2d_vector:
    params:
      - id: record_type
        type: str
      - id: nrows
        type: u4
    seq:
      - id: rec_size1
        type: u4
      - id: vector
        type: vector_values(record_type)
        repeat: expr
        repeat-expr: nrows
        size: rec_size1 / nrows
      - id: rec_size2
        type: u4
  vector_values:
    params:
      - id: record_type
        type: str
    seq:
      - id: values
        type:
          switch-on: record_type
          cases:
            '"u4"': u4
            '"u8"': u8
            '"f4"': f4
            '"f8"': f8
        repeat: eos
  fortran_skip:
    seq:
      - id: rec_size1
        type: u4
      - id: contents
        size: rec_size1
      - id: rec_size2
        type: u4
  charstring:
    seq:
      - id: rec_size1
        type: u4
      - id: contents
        type: str
        size: rec_size1
        encoding: ascii
      - id: rec_size2
        type: u4
