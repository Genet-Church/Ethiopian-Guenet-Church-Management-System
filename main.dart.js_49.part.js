((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var B,C,A={aMU:function aMU(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},aMV:function aMV(){},LA:function LA(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},a4P:function a4P(){},CF:function CF(d,e,f){var _=this
_.b=_.w=null
_.c=!1
_.vH$=d
_.di$=e
_.ak$=f
_.a=null},a3q:function a3q(d,e,f,g,h,i,j){var _=this
_.fm=d
_.y1=e
_.y2=f
_.bd$=g
_.P$=h
_.bk$=i
_.b=_.dy=null
_.c=0
_.y=_.d=null
_.z=!0
_.Q=null
_.as=!1
_.at=null
_.ay=$
_.ch=j
_.CW=!1
_.cx=$
_.cy=!0
_.db=!1
_.dx=$},
b9T(d,e,f,g,h,i,j,k){var x,w=null
if(j==null){x=d==null
x=x?C.i7:w}else x=j
return new A.wF(f,new B.CE(g,h,!0,!0,!0,B.bcP(),w),i,C.a6,!1,d,w,x,w,k,w,0,w,h,C.fD,e,w,w,C.Q,C.aX,w)},
wF:function wF(d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x){var _=this
_.rx=d
_.ry=e
_.db=f
_.c=g
_.d=h
_.e=i
_.f=j
_.r=k
_.w=l
_.x=m
_.y=n
_.z=o
_.Q=p
_.as=q
_.at=r
_.ax=s
_.ay=t
_.ch=u
_.CW=v
_.cx=w
_.a=x},
a4O:function a4O(d,e,f){this.f=d
this.d=e
this.a=f}}
B=c[0]
C=c[2]
A=a.updateHolder(c[44],A)
A.aMU.prototype={
aaR(d){var x=this.c
return d.uT(this.d,x,x)},
j(d){var x=this
return"SliverGridGeometry("+C.b.bL(B.b(["scrollOffset: "+B.p(x.a),"crossAxisOffset: "+B.p(x.b),"mainAxisExtent: "+B.p(x.c),"crossAxisExtent: "+B.p(x.d)],y.x),", ")+")"}}
A.aMV.prototype={}
A.LA.prototype={
ab0(d){var x=this.b
if(x>0)return Math.max(0,this.a*C.d.ll(d/x)-1)
return 0},
ao2(d){var x,w,v=this
if(v.f){x=v.c
w=v.e
return v.a*x-d-w-(x-w)}return d},
Ix(d){var x=this,w=x.a,v=C.i.bc(d,w)
return new A.aMU(C.i.kk(d,w)*x.b,x.ao2(v*x.c),x.d,x.e)},
a4n(d){var x
if(d===0)return 0
x=this.b
return x*(C.i.kk(d-1,this.a)+1)-(x-this.d)}}
A.a4P.prototype={}
A.CF.prototype={
j(d){return"crossAxisOffset="+B.p(this.w)+"; "+this.afq(0)}}
A.a3q.prototype={
eP(d){if(!(d.b instanceof A.CF))d.b=new A.CF(!1,null,null)},
sabw(d){var x=this
if(x.fm===d)return
if(B.w(d)!==B.w(x.fm)||d.kh(x.fm))x.a6()
x.fm=d},
v5(d){var x=d.b
x.toString
x=y.t.a(x).w
x.toString
return x},
c0(){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4,a5,a6=this,a7=null,a8=y.z.a(B.q.prototype.gU.call(a6)),a9=a6.y1
a9.R8=!1
x=a8.d
w=x+a8.z
v=w+a8.Q
u=a6.fm.Bp(a8)
t=u.b
s=t>1e-10?u.a*C.d.kk(w,t):0
r=isFinite(v)?u.ab0(v):a7
if(a6.P$!=null){q=a6.a3X(s)
a6.rr(q,r!=null?a6.a3Y(r):0)}else a6.rr(0,0)
p=u.Ix(s)
if(a6.P$==null)if(!a6.Ns(s,p.a)){o=u.a4n(a9.gv4())
a6.dy=B.jx(a7,!1,a7,a7,o,0,0,0,o,a7)
a9.rA()
return}n=p.a
m=n+p.c
t=a6.P$
t.toString
t=t.b
t.toString
l=y.c
t=l.a(t).b
t.toString
k=t-1
t=y.t
j=a7
for(;k>=s;--k){i=u.Ix(k)
h=i.c
g=a6.a7g(a8.uT(i.d,h,h))
f=g.b
f.toString
t.a(f)
e=i.a
f.a=e
f.w=i.b
if(j==null)j=g
m=Math.max(m,e+h)}if(j==null){h=a6.P$
h.toString
h.hF(p.aaR(a8))
j=a6.P$
h=j.b
h.toString
t.a(h)
h.a=n
h.w=p.b}h=j.b
h.toString
h=l.a(h).b
h.toString
k=h+1
h=B.j(a6).i("ad.1")
f=r!=null
for(;;){if(!(!f||k<=r)){d=!1
break}i=u.Ix(k)
e=i.c
a0=a8.uT(i.d,e,e)
a1=j.b
a1.toString
g=h.a(a1).ak$
if(g!=null){a1=g.b
a1.toString
a1=l.a(a1).b
a1.toString
a1=a1!==k}else a1=!0
if(a1){g=a6.a7e(a0,j)
if(g==null){d=!0
break}}else g.hF(a0)
a1=g.b
a1.toString
t.a(a1)
a2=i.a
a1.a=a2
a1.w=i.b
m=Math.max(m,a2+e);++k
j=g}t=a6.bk$
t.toString
t=t.b
t.toString
t=l.a(t).b
t.toString
a3=d?m:a9.Pr(a8,s,t,n,m)
a4=a6.v1(a8,Math.min(x,n),m)
a5=a6.v0(a8,n,m)
a6.dy=B.jx(a5,a3>a4||x>0||a8.f!==0,a7,a7,a3,0,a4,0,a3,a7)
if(a3===m)a9.R8=!0
a9.rA()}}
A.wF.prototype={
a3M(d){return new A.a4O(this.rx,this.ry,null)}}
A.a4O.prototype={
b6(d){var x=new A.a3q(this.f,y.v.a(d),B.D(y.e,y.g),0,null,null,B.ao(y.d))
x.b5()
return x},
bi(d,e){e.sabw(this.f)},
Pq(d,e,f,g,h){var x
this.afr(d,e,f,g,h)
x=this.f.Bp(d).a4n(this.d.gvz())
return x}}
var z=a.updateTypes([]);(function inheritance(){var x=a.inheritMany,w=a.inherit
x(B.m,[A.aMU,A.aMV,A.a4P])
w(A.LA,A.aMV)
w(A.CF,B.hK)
w(A.a3q,B.ox)
w(A.wF,B.Gf)
w(A.a4O,B.n8)})()
B.cq(b.typeUniverse,JSON.parse('{"CF":{"hK":[],"qI":[],"eP":["u"],"mQ":[],"dy":[]},"a3q":{"ox":[],"cU":[],"ad":["u","hK"],"q":[],"ax":[],"ad.1":"hK","ad.0":"u"},"wF":{"aa":[],"c":[]},"a4O":{"n8":[],"aA":[],"c":[]}}'))
var y={d:B.v("ek"),x:B.v("o<h>"),g:B.v("u"),z:B.v("n7"),t:B.v("CF"),v:B.v("uk"),c:B.v("hK"),e:B.v("k")}};
(a=>{a["PR8PcBpm6uLst+eKZhlvPo0NSvI="]=a.current})($__dart_deferred_initializers__);