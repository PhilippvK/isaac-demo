; ModuleID = '/tmp/isaac-bbid-investigation/cases.c'
source_filename = "/tmp/isaac-bbid-investigation/cases.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local i32 @choose(i32 noundef %a, i32 noundef %b) local_unnamed_addr #0 !dbg !11 {
entry:
    #dbg_value(i32 %a, !17, !DIExpression(), !19)
    #dbg_value(i32 %b, !18, !DIExpression(), !19)
  %cmp = icmp slt i32 %a, %b, !dbg !20
  %add = add nsw i32 %a, 3, !dbg !21
  %sub = add nsw i32 %b, -5, !dbg !21
  %cond = select i1 %cmp, i32 %add, i32 %sub, !dbg !21
  ret i32 %cond, !dbg !22
}

; Function Attrs: nounwind
define dso_local i32 @loop(ptr nocapture noundef readonly %p, i32 noundef %n) local_unnamed_addr #1 !dbg !23 {
entry:
    #dbg_value(ptr %p, !28, !DIExpression(), !33)
    #dbg_value(i32 %n, !29, !DIExpression(), !33)
    #dbg_value(i32 0, !30, !DIExpression(), !33)
    #dbg_value(i32 0, !31, !DIExpression(), !34)
  %cmp11 = icmp sgt i32 %n, 0, !dbg !35
  br i1 %cmp11, label %for.body, label %for.cond.cleanup, !dbg !37

for.cond.cleanup:                                 ; preds = %for.inc, %entry
  %s.0.lcssa = phi i32 [ 0, %entry ], [ %s.1, %for.inc ], !dbg !33
  ret i32 %s.0.lcssa, !dbg !38

for.body:                                         ; preds = %entry, %for.inc
  %i.013 = phi i32 [ %inc, %for.inc ], [ 0, %entry ]
  %s.012 = phi i32 [ %s.1, %for.inc ], [ 0, %entry ]
    #dbg_value(i32 %i.013, !31, !DIExpression(), !34)
    #dbg_value(i32 %s.012, !30, !DIExpression(), !33)
  %arrayidx = getelementptr inbounds i32, ptr %p, i32 %i.013, !dbg !39
  %0 = load i32, ptr %arrayidx, align 4, !dbg !39, !tbaa !42
  %and = and i32 %0, 1, !dbg !46
  %tobool.not = icmp eq i32 %and, 0, !dbg !46
  br i1 %tobool.not, label %if.else, label %if.then, !dbg !47

if.then:                                          ; preds = %for.body
  %call = tail call i32 @side(i32 noundef %0) #3, !dbg !48
  %add = add nsw i32 %call, %s.012, !dbg !49
    #dbg_value(i32 %add, !30, !DIExpression(), !33)
  br label %for.inc, !dbg !50

if.else:                                          ; preds = %for.body
  %xor = xor i32 %0, %s.012, !dbg !51
    #dbg_value(i32 %xor, !30, !DIExpression(), !33)
  br label %for.inc

for.inc:                                          ; preds = %if.then, %if.else
  %s.1 = phi i32 [ %add, %if.then ], [ %xor, %if.else ], !dbg !52
    #dbg_value(i32 %s.1, !30, !DIExpression(), !33)
  %inc = add nuw nsw i32 %i.013, 1, !dbg !53
    #dbg_value(i32 %inc, !31, !DIExpression(), !34)
  %exitcond.not = icmp eq i32 %inc, %n, !dbg !35
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !dbg !37, !llvm.loop !54
}

declare !dbg !57 dso_local i32 @side(i32 noundef) local_unnamed_addr #2

; Function Attrs: nounwind
define dso_local i32 @dispatch(i32 noundef %x) local_unnamed_addr #1 !dbg !60 {
entry:
    #dbg_value(i32 %x, !62, !DIExpression(), !63)
  switch i32 %x, label %sw.default [
    i32 1, label %sw.bb
    i32 4, label %sw.bb1
    i32 9, label %return
  ], !dbg !64

sw.bb:                                            ; preds = %entry
  %call = tail call i32 @side(i32 noundef 8) #3, !dbg !65
  br label %return, !dbg !67

sw.bb1:                                           ; preds = %entry
  %call2 = tail call i32 @side(i32 noundef 3) #3, !dbg !68
  %add = add nsw i32 %call2, 2, !dbg !69
  br label %return, !dbg !70

sw.default:                                       ; preds = %entry
  %xor = xor i32 %x, 42, !dbg !71
  br label %return, !dbg !72

return:                                           ; preds = %entry, %sw.default, %sw.bb1, %sw.bb
  %retval.0 = phi i32 [ %xor, %sw.default ], [ %add, %sw.bb1 ], [ %call, %sw.bb ], [ 16, %entry ], !dbg !73
  ret i32 %retval.0, !dbg !74
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+m,+relax,+zmmul,-a,-b,-c,-d,-e,-experimental-smmpm,-experimental-smnpm,-experimental-ssnpm,-experimental-sspm,-experimental-ssqosid,-experimental-supm,-experimental-zalasr,-experimental-zfbfmin,-experimental-zicfilp,-experimental-zicfiss,-experimental-ztso,-experimental-zvfbfmin,-experimental-zvfbfwma,-f,-h,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smepmp,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zicsr,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+m,+relax,+zmmul,-a,-b,-c,-d,-e,-experimental-smmpm,-experimental-smnpm,-experimental-ssnpm,-experimental-sspm,-experimental-ssqosid,-experimental-supm,-experimental-zalasr,-experimental-zfbfmin,-experimental-zicfilp,-experimental-zicfiss,-experimental-ztso,-experimental-zvfbfmin,-experimental-zvfbfwma,-f,-h,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smepmp,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zicsr,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+m,+relax,+zmmul,-a,-b,-c,-d,-e,-experimental-smmpm,-experimental-smnpm,-experimental-ssnpm,-experimental-sspm,-experimental-ssqosid,-experimental-supm,-experimental-zalasr,-experimental-zfbfmin,-experimental-zicfilp,-experimental-zicfiss,-experimental-ztso,-experimental-zvfbfmin,-experimental-zvfbfwma,-f,-h,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smepmp,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zicsr,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 19.0.0git (git@github.com:PhilippvK/llvm-project.git 54c047b2f03e74e271f60f00a038a1baa4872a2f)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/tmp/isaac-bbid-investigation/cases.c", directory: "/var/tmp/ga87puy/isaac-demo-new", checksumkind: CSK_MD5, checksum: "07f226917146ac66d38aceb94ef2aea1")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 1, !"target-abi", !"ilp32"}
!6 = !{i32 6, !"riscv-isa", !7}
!7 = !{!"rv32i2p1_m2p0_zmmul1p0"}
!8 = !{i32 8, !"SmallDataLimit", i32 8}
!9 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!10 = !{!"clang version 19.0.0git (git@github.com:PhilippvK/llvm-project.git 54c047b2f03e74e271f60f00a038a1baa4872a2f)"}
!11 = distinct !DISubprogram(name: "choose", scope: !12, file: !12, line: 2, type: !13, scopeLine: 2, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !16)
!12 = !DIFile(filename: "/tmp/isaac-bbid-investigation/cases.c", directory: "", checksumkind: CSK_MD5, checksum: "07f226917146ac66d38aceb94ef2aea1")
!13 = !DISubroutineType(types: !14)
!14 = !{!15, !15, !15}
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{!17, !18}
!17 = !DILocalVariable(name: "a", arg: 1, scope: !11, file: !12, line: 2, type: !15)
!18 = !DILocalVariable(name: "b", arg: 2, scope: !11, file: !12, line: 2, type: !15)
!19 = !DILocation(line: 0, scope: !11)
!20 = !DILocation(line: 2, column: 37, scope: !11)
!21 = !DILocation(line: 2, column: 35, scope: !11)
!22 = !DILocation(line: 2, column: 28, scope: !11)
!23 = distinct !DISubprogram(name: "loop", scope: !12, file: !12, line: 3, type: !24, scopeLine: 3, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !27)
!24 = !DISubroutineType(types: !25)
!25 = !{!15, !26, !15}
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 32)
!27 = !{!28, !29, !30, !31}
!28 = !DILocalVariable(name: "p", arg: 1, scope: !23, file: !12, line: 3, type: !26)
!29 = !DILocalVariable(name: "n", arg: 2, scope: !23, file: !12, line: 3, type: !15)
!30 = !DILocalVariable(name: "s", scope: !23, file: !12, line: 4, type: !15)
!31 = !DILocalVariable(name: "i", scope: !32, file: !12, line: 5, type: !15)
!32 = distinct !DILexicalBlock(scope: !23, file: !12, line: 5, column: 3)
!33 = !DILocation(line: 0, scope: !23)
!34 = !DILocation(line: 0, scope: !32)
!35 = !DILocation(line: 5, column: 21, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !12, line: 5, column: 3)
!37 = !DILocation(line: 5, column: 3, scope: !32)
!38 = !DILocation(line: 9, column: 3, scope: !23)
!39 = !DILocation(line: 6, column: 9, scope: !40)
!40 = distinct !DILexicalBlock(scope: !41, file: !12, line: 6, column: 9)
!41 = distinct !DILexicalBlock(scope: !36, file: !12, line: 5, column: 31)
!42 = !{!43, !43, i64 0}
!43 = !{!"int", !44, i64 0}
!44 = !{!"omnipotent char", !45, i64 0}
!45 = !{!"Simple C/C++ TBAA"}
!46 = !DILocation(line: 6, column: 14, scope: !40)
!47 = !DILocation(line: 6, column: 9, scope: !41)
!48 = !DILocation(line: 6, column: 24, scope: !40)
!49 = !DILocation(line: 6, column: 21, scope: !40)
!50 = !DILocation(line: 6, column: 19, scope: !40)
!51 = !DILocation(line: 7, column: 12, scope: !40)
!52 = !DILocation(line: 0, scope: !40)
!53 = !DILocation(line: 5, column: 26, scope: !36)
!54 = distinct !{!54, !37, !55, !56}
!55 = !DILocation(line: 8, column: 3, scope: !32)
!56 = !{!"llvm.loop.mustprogress"}
!57 = !DISubprogram(name: "side", scope: !12, file: !12, line: 1, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!58 = !DISubroutineType(types: !59)
!59 = !{!15, !15}
!60 = distinct !DISubprogram(name: "dispatch", scope: !12, file: !12, line: 11, type: !58, scopeLine: 11, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !61)
!61 = !{!62}
!62 = !DILocalVariable(name: "x", arg: 1, scope: !60, file: !12, line: 11, type: !15)
!63 = !DILocation(line: 0, scope: !60)
!64 = !DILocation(line: 12, column: 3, scope: !60)
!65 = !DILocation(line: 13, column: 18, scope: !66)
!66 = distinct !DILexicalBlock(scope: !60, file: !12, line: 12, column: 14)
!67 = !DILocation(line: 13, column: 11, scope: !66)
!68 = !DILocation(line: 14, column: 18, scope: !66)
!69 = !DILocation(line: 14, column: 26, scope: !66)
!70 = !DILocation(line: 14, column: 11, scope: !66)
!71 = !DILocation(line: 16, column: 21, scope: !66)
!72 = !DILocation(line: 16, column: 12, scope: !66)
!73 = !DILocation(line: 0, scope: !66)
!74 = !DILocation(line: 18, column: 1, scope: !60)
