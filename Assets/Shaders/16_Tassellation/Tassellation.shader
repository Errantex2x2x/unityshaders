Shader "Custom/Tesselation displacement"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Tess("Tessellation", Range(1, 100)) = 4
		_MainTex("Base (RGB)", 2D) = "white" {}
	_DispTex("Disp Texture", 2D) = "gray" {}
	_NormalMap("Normalmap", 2D) = "bump" {}
	_Displacement("Displacement", Float) = 0.3
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}

		SubShader
	{
		Tags{ "RenderType" = "Opaque" }

		CGPROGRAM
#pragma surface surf CustomPBR addshadow fullforwardshadows tessellate:tessDistance
#pragma vertex vert
#pragma target 5.0

#include "Tessellation.cginc"
#include "UnityPBSLighting.cginc"

		sampler2D _DispTex;
	sampler2D _MainTex;
	sampler2D _NormalMap;

	float _Displacement;
	float _Tess;

	half _Glossiness;
	half _Metallic;
	fixed4 _Color;

	struct Input
	{
		float2 uv_MainTex;
	};

	struct AppData
	{
		float4 vertex : POSITION;
		float4 tangent : TANGENT;
		float3 normal : NORMAL;
		float2 texcoord : TEXCOORD0;
		float4 color : COLOR;
	};

	float4 tessDistance(AppData v0, AppData v1, AppData v2)
	{
		float minDist = 10.0;
		float maxDist = 300.0;
		return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
	}

	void vert(inout AppData v)
	{
		float d = tex2Dlod(_DispTex, float4(v.texcoord.xy,0,0)).r * _Displacement;
		v.vertex.xyz += v.normal * d;
	}

	inline fixed4 LightingCustomPBR(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
	{
		fixed4 pbr = LightingStandard(s, viewDir, gi);

		return pbr;
	}

	void LightingCustomPBR_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
	{
		LightingStandard_GI(s, data, gi);
	}

	void surf(Input IN, inout SurfaceOutputStandard o)
	{
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

		o.Albedo = c.rgb;

		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
		o.Alpha = c.a;
	}

	ENDCG
	}

		FallBack "Diffuse"
}