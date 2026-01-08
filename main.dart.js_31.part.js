((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
axJ(d,e,f,g,h,i,j){var x,w=null,v=Math.max(0,e*2-1)
if(g==null){x=h===C.a6
x=x?C.i7:w}else x=g
return new A.Bo(new A.CE(new B.axK(d,i),v,!0,!0,!0,new B.axL(),w),f,h,!1,w,w,x,w,j,w,0,w,e,C.fD,C.a7,w,w,C.Q,C.aX,w)},
axK:function axK(d,e){this.a=d
this.b=e},
axL:function axL(){},
vu:function vu(d,e){this.a=d
this.b=e},
eM:function eM(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
bq8(){return new B.vs()},
vs:function vs(){this.a=$},
akV:function akV(){}},D,E
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[20],B)
D=c[90]
E=c[29]
B.vu.prototype={
M(){return"ActivityType."+this.b}}
B.eM.prototype={
ga72(){switch(this.d.a){case 0:return C.iM
case 1:return C.bE
case 2:return C.cY
case 3:return C.iG
case 4:return D.Ww}}}
B.vs.prototype={
cM(){var x=0,w=A.B(y.U),v,u=2,t=[],s=this,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4,a5,a6
var $async$cM=A.C(function(a7,a8){if(a7===1){t.push(a8)
x=u}for(;;)switch(x){case 0:a4=s.a
a4===$&&A.a()
e=a4.aB($.ft(),y._)
if(e==null){v=A.b([],y.r)
x=1
break}r=A.b([],y.r)
d=e.d
x=A.fc(d)===C.bd?3:5
break
case 3:q=A.b([],y.j)
p=A.b([],y.C)
u=7
x=10
return A.r(A.jq(A.b([a4.aB($.mp().gh3(),y.L),a4.aB($.rv().gh3(),y.H)],y.Y),y.Q),$async$cM)
case 10:o=a8
q=y.G.a(J.cu(o,0))
p=y.t.a(J.cu(o,1))
u=2
x=9
break
case 7:u=6
a5=t.pop()
x=9
break
case 6:x=2
break
case 9:for(a4=J.bl(p);a4.v();){a1=a4.gN()
if(A.fc(d)===C.bd&&a1.d!=null){a1=a1.d
a2=a1.b
a1=E.rT(a1.f)
if(a1==null)a1=new A.cn(Date.now(),0,!1)
J.e6(r,new B.eM("New Pastor Added",a2+" joined the pastoral team.",a1,D.rs,"/report-pastors"))}}for(a4=J.bl(q);a4.v();){d=a4.gN()
a1=d.b
d=d.e
d=E.rT(d==null?"":d)
if(d==null)d=new A.cn(Date.now(),0,!1)
J.e6(r,new B.eM("New Church Registered",a1+" is now part of the network.",d,D.Nf,"/report-churchs"))}x=4
break
case 5:x=A.fc(d)===C.b2?11:12
break
case 11:n=a4.aB($.ih(),y.T)
x=n!=null?13:14
break
case 13:m=a4.aB($.ei(),y.M)
u=16
x=19
return A.r(A.jq(A.b([m.ab3(n,10),m.wP(n,10),m.wI(n)],y.D),y.K),$async$cM)
case 19:l=a8
k=y.d.a(J.cu(l,0)).a
j=y.O.a(J.cu(l,1)).a
i=y.h.a(J.cu(l,2))
for(a4=k,d=a4.length,a3=0;a3<a4.length;a4.length===d||(0,A.R)(a4),++a3){h=a4[a3]
a1=h.b
a2=h.fr
a2=E.rT(a2==null?"":a2)
if(a2==null)a2=new A.cn(Date.now(),0,!1)
J.e6(r,new B.eM("New Member Added",a1+" joined the church.",a2,D.Ng,"/show-members"))}for(a4=j,d=a4.length,a3=0;a3<a4.length;a4.length===d||(0,A.R)(a4),++a3){g=a4[a3]
if(g.e!=null){a1=g.e.b
a2=E.rT(g.e.f)
if(a2==null)a2=new A.cn(Date.now(),0,!1)
J.e6(r,new B.eM("New Servant Added",a1+" joined the serving team.",a2,D.Ni,"/report-servants"))}}for(a4=J.bl(i);a4.v();){f=a4.gN()
d=f.b
a1=f.d
a1=E.rT(a1==null?"":a1)
if(a1==null)a1=new A.cn(Date.now(),0,!1)
J.e6(r,new B.eM("New Department Created",d+" department was created.",a1,D.Nh,"/departments"))}u=2
x=18
break
case 16:u=15
a6=t.pop()
x=18
break
case 15:x=2
break
case 18:case 14:case 12:case 4:J.TQ(r,new B.akV())
v=r
x=1
break
case 1:return A.z(v,w)
case 2:return A.y(t.at(-1),w)}})
return A.A($async$cM,w)}}
var z=a.updateTypes(["k(eM,eM)","vs()"])
B.axK.prototype={
$2(d,e){var x=C.i.cQ(e,2)
if((e&1)===0)return this.a.$2(d,x)
return this.b.$2(d,x)},
$S:791}
B.axL.prototype={
$2(d,e){return(e&1)===0?C.i.cQ(e,2):null},
$S:792}
B.akV.prototype={
$2(d,e){return e.c.bW(0,d.c)},
$S:z+0};(function installTearOffs(){var x=a._static_0
x(B,"bGh","bq8",1)})();(function inheritance(){var x=a.inheritMany,w=a.inherit
x(A.es,[B.axK,B.axL,B.akV])
w(B.vu,A.iE)
w(B.eM,A.m)
w(B.vs,A.iH)})()
A.cq(b.typeUniverse,JSON.parse('{"vs":{"iH":["t<eM>"],"hp":["t<eM>"],"jO":["t<eM>"],"hp.0":"t<eM>"}}'))
var y=(function rtii(){var x=A.v
return{M:x("ik"),L:x("a8<t<c4>>"),H:x("a8<t<d9>>"),r:x("o<eM>"),j:x("o<c4>"),Y:x("o<a8<t<m>>>"),D:x("o<a8<m>>"),C:x("o<d9>"),U:x("t<eM>"),G:x("t<c4>"),h:x("t<cS>"),Q:x("t<m>"),t:x("t<d9>"),K:x("m"),d:x("kf<cE>"),O:x("kf<dL>"),T:x("h?"),_:x("ey?")}})();(function constants(){D.rs=new B.vu(0,"pastor")
D.Nf=new B.vu(1,"church")
D.Ng=new B.vu(2,"member")
D.Nh=new B.vu(3,"department")
D.Ni=new B.vu(4,"servant")
D.p_=new A.aK(59655,"iconsax","iconsax",!1)
D.Ww=new A.aK(60507,"iconsax","iconsax",!1)})();(function lazyInitializers(){var x=a.lazyFinal
x($,"bMB","b8s",()=>A.FS(B.bGh(),null,null,null,"activityLogProvider",A.v("vs"),y.U))})()};
(a=>{a["104O+cgyaiP586z3B6hvy13dAao="]=a.current})($__dart_deferred_initializers__);