// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Cg texture phong vertex"
{
	Properties
	{
		_MainTex("Main texture", 2D) = "White" {}
	_LightDir("Light direction", Vector) = (1.0, 0.0, 0.0, 0.0)
		_LightColor("Light color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", Range(0.0, 128)) = 10
	}

		SubShader
	{
		Blend SrcAlpha OneMinusSrcAlpha
		Tags{ "Queue" = "Transparent" }

		Pass
	{
		CGPROGRAM

		// Define what functions are used for the vertex shader and for the fragment shader
#pragma vertex vert
#pragma fragment frag


#include "UnityCG.cginc"

		sampler2D _MainTex;
	float4 _MainTex_ST; // Required to have unity fill the values from the sampler

	float3 _LightDir;
	float3 _LightColor;
	float _Shininess;


	// Shader input definition
	struct AppData {
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : NORMAL;
	};

	// Structure used for passing data from vertex to fragment shader
	struct VertexToFragment {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float3 lightColor : COLOR0;
		float3 specularColor : COLOR1;
	};

	// Vertex Shader
	VertexToFragment vert(AppData input) {
		VertexToFragment output;

		// Transform vertex position and uv
		output.pos = UnityObjectToClipPos(input.vertex);
		output.uv = TRANSFORM_TEX(input.uv, _MainTex);

		// Normalize light and view vectors
		float3 lightDir = normalize(_LightDir);
		float3 viewDir = normalize(ObjSpaceViewDir(input.vertex));

		// Compute diffuse
		float diffuseComponent = max(0.0, dot(lightDir, input.normal));
		// Compute compute reflection
		float3 reflectedLightDir = reflect(-lightDir, input.normal);
		// Compute specularity
		float specularComponent = max(0.0f, dot(reflectedLightDir, viewDir));

		// Compute diffuse color with light and combine it with specular component and shiness for highlight
		output.lightColor = _LightColor * diffuseComponent;
		output.specularColor = _LightColor * pow(specularComponent, _Shininess);

		return output;
	}

	// Fragment Shader
	float4 frag(VertexToFragment input) : COLOR
	{
		// Fragment simply gets tecture color and apply diffuse/light and specular/brightness
		float4 textureColor = tex2D(_MainTex, input.uv);

		textureColor.rgb *= input.lightColor;
		textureColor.rgb *= input.specularColor;

		return textureColor;
	}

		ENDCG
	}

	}

}
