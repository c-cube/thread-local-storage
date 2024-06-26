module TLS = Thread_local_storage

let k1 : int TLS.t = TLS.create ()

let () =
  let n = 1_000_000 in
  let values = Array.make 20 0 in

  let threads =
    Array.init 20 (fun t_idx ->
        Thread.create
          (fun () ->
            TLS.set k1 0;
            for _i = 1 to n do
              let r = TLS.get k1 in
              TLS.set k1 (r + 1)
            done;
            values.(t_idx) <- TLS.get k1)
          ())
  in

  Array.iter Thread.join threads;
  Array.iter (fun x -> assert (x = n)) values

let k2 : int ref TLS.t = TLS.create ()
let k3 : int ref TLS.t = TLS.create ()

let () =
  let res = ref (0, 0) in
  let run () =
    TLS.set k2 (ref 0);
    TLS.set k3 (ref 0);
    for _i = 1 to 1000 do
      let r2 = TLS.get k2 in
      incr r2;
      let r3 = TLS.get k3 in
      r3 := !r3 + 2
    done;
    res := !(TLS.get k2), !(TLS.get k3)
  in

  let t = Thread.create run () in
  Thread.join t;

  assert (!res = (1000, 2000))
