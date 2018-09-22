Shader "Custom/Cg unlit blend texture"
{
    Properties
    {
        _MainColor("Main color", Color) = (1.0, 1.0, 1.0, 1.0)
        _FirstTex("First texture", 2D) = "White" {}
        _SecondTex("Second texture", 2D) = "White" {}
        _MaskTex("Mask texture", 2D) = "White" {}
        _BlendStrength("Blend Strength", Range(0.0, 1.0)) = 0.0
       
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

            sampler2D _FirstTex;
            float4 _FirstTex_ST; // Required to have unity fill the values from the sampler

            sampler2D _SecondTex;
            float4 _SecondTex_ST; // Required to have unity fill the values from the sampler

            sampler2D _MaskTex;
            float4 _MaskTex_ST; // Required to have unity fill the values from the sampler

            float4 _MainColor;

            float _BlendStrength;

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
            	float2 uv0 : TEXCOORD0; // First UV channel
            	float2 uv1 : TEXCOORD1; // First UV channel
            	float2 uv2 : TEXCOORD2; // First UV channel
            };

            // Vertex Shader
            VertexToFragment vert(AppData input)
            {
            	VertexToFragment output;

            	output.pos = UnityObjectToClipPos(input.vertex);

				// Transform all uvs with the info of the first uv channel
            	output.uv0 = TRANSFORM_TEX(input.uv, _FirstTex);
            	output.uv1 = TRANSFORM_TEX(input.uv, _SecondTex);
            	output.uv2 = TRANSFORM_TEX(input.uv, _MaskTex);

            	return output;
            }

            // Fragment Shader
            float4 frag(VertexToFragment input) : COLOR
            {
				// Get texture colors
  				float4 FirstTexColor = tex2D(_FirstTex, input.uv0);
  				float4 SecondTexColor = tex2D(_SecondTex, input.uv1);
				// Get mask and multiply by strength
  				float4 MaskValue = tex2D(_MaskTex, input.uv2) * _BlendStrength;

				// Return color lerp
            	return lerp(FirstTexColor, SecondTexColor, MaskValue.g) * _MainColor;
            }
            ENDCG
        }
    }
}