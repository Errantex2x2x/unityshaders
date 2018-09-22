Shader "Custom/Cg unlit texture"
{
	Properties
	{
		_MainColor("Main color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex("Main texture", 2D) = "White" {}

	}

		SubShader
	{
		Pass
	{
		CGPROGRAM

		// Define what functions are used for the vertex shader and for the fragment shader
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

	sampler2D _MainTex;
	float4 _MainTex_ST; // Required to have unity fill the values from the sampler

	float4 _MainColor;

	// Shader input definition
	struct AppData
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0; // First UV channel
	};

	// Structure used for passing data from vertex to fragment shader
	struct VertexToFragment
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0; // First UV channel
	};

	// Vertex Shader
	VertexToFragment vert(AppData input)
	{
		VertexToFragment output;

		output.pos = UnityObjectToClipPos(input.vertex);

		// Transform uv with engine data
		output.uv = TRANSFORM_TEX(input.uv, _MainTex);;
		// Do not transform uv 
		//output.uv = input.uv;

		return output;
	}

	// Fragment Shader
	float4 frag(VertexToFragment input) : COLOR
	{
		// Get M
		float4 textureColor = tex2D(_MainTex, input.uv);
		return textureColor * _MainColor;
	}
		ENDCG
	}
	}
}