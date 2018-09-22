// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Cg basic transparency shader" 
{
	Properties 
	{
		_MainColor("Main color", Color) = (1.0, 1.0, 1.0, 1.0)
		_FirstTex("First texture", 2D) = "White" {}
		_SecondTex("Second texture", 2D) = "White" {}
		_MaskTex("Mask texture", 2D) = "White" {}
		_BlendStrength("Blend Strength", Range(0.0, 1.0)) = 0.0
		_Transparency("Transparency", Range(0.0, 1.0)) = 0.0
	}
	
	SubShader 
	{
		Blend SrcAlpha OneMinusSrcAlpha
		Tags{ "Queue" = "Transparent" }
		
			Pass
			{
				Cull Front
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

				float _Transparency;

				// Shader input definition
				struct AppData {
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0; // First UV channel
				};

				// Structure used for passing data from vertex to fragment shader
				struct VertexToFragment {
					float4 pos : SV_POSITION;
					float2 uv0 : TEXCOORD0; // First UV channel
					float2 uv1 : TEXCOORD1; // First UV channel
					float2 uv2 : TEXCOORD2; // First UV channel
				};

				// Vertex Shader
				VertexToFragment vert(AppData input) {
					VertexToFragment output;

					// transform model coordinate to world coordinates and then to clip coordinates
					output.pos = UnityObjectToClipPos(input.vertex);

					// use texture coordinate of first texture to map every texture we have 
					output.uv0 = TRANSFORM_TEX(input.uv, _FirstTex);
					output.uv1 = TRANSFORM_TEX(input.uv, _SecondTex);
					output.uv2 = TRANSFORM_TEX(input.uv, _MaskTex);
					//output.uv0 = input.uv;
					//output.uv1 = input.uv;
					//output.uv2 = input.uv;

					return output;
				}

				// Fragment Shader
				float4 frag(VertexToFragment input) : COLOR
				{
					// get color of uv from the texture01
					float4 FirstTexColor = tex2D(_FirstTex, input.uv0);
					float4 SecondTexColor = tex2D(_SecondTex, input.uv1);
					float4 MaskValue = tex2D(_MaskTex, input.uv2) * _BlendStrength;

					// interpolate values between FirstTexColor and SecondTexColor following the values of the mask
					float4 final = lerp(FirstTexColor, SecondTexColor, MaskValue.r);
					//final.a = 0.2;


					//// screenPos.xy will contain pixel integer coordinates.
					//// use them to implement a checkerboard pattern that skips rendering
					//// 4x4 blocks of pixels

					//// checker value will be negative for 4x4 blocks of pixels
					//// in a checkerboard pattern
					//input.pos.xy = floor(input.pos.xy * 0.25) * 0.5;
					//float checker = -frac(input.pos.r + input.pos.g);

					//// clip HLSL instruction stops rendering a pixel if value is negative
					//clip(checker);

					//// for pixels that were kept, read the texture and output it
					////fixed4 c = tex2D(_MainTex, i.uv);
					////return c;
					final.a = _Transparency;
					return final;
				}

				ENDCG
		}


		Pass
		{
			Cull Back
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

			float _Transparency;

			// Shader input definition
			struct AppData {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0; // First UV channel
			};

			// Structure used for passing data from vertex to fragment shader
			struct VertexToFragment {
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0; // First UV channel
				float2 uv1 : TEXCOORD1; // First UV channel
				float2 uv2 : TEXCOORD2; // First UV channel
			};

			// Vertex Shader
			VertexToFragment vert(AppData input) {
				VertexToFragment output;

				// transform model coordinate to world coordinates and then to clip coordinates
				output.pos = UnityObjectToClipPos(input.vertex);

				// use texture coordinate of first texture to map every texture we have 
				output.uv0 = TRANSFORM_TEX(input.uv, _FirstTex);
				output.uv1 = TRANSFORM_TEX(input.uv, _SecondTex);
				output.uv2 = TRANSFORM_TEX(input.uv, _MaskTex);
				//output.uv0 = input.uv;
				//output.uv1 = input.uv;
				//output.uv2 = input.uv;

				return output;
			}

			// Fragment Shader
			float4 frag(VertexToFragment input) : COLOR
			{
				// get color of uv from the texture01
				float4 FirstTexColor = tex2D(_FirstTex, input.uv0);
				float4 SecondTexColor = tex2D(_SecondTex, input.uv1);
				float4 MaskValue = tex2D(_MaskTex, input.uv2) * _BlendStrength;

				// interpolate values between FirstTexColor and SecondTexColor following the values of the mask
				float4 final = lerp(FirstTexColor, SecondTexColor, MaskValue.r) * _MainColor;
				//final.a = 0.2;


				//// screenPos.xy will contain pixel integer coordinates.
				//// use them to implement a checkerboard pattern that skips rendering
				//// 4x4 blocks of pixels

				//// checker value will be negative for 4x4 blocks of pixels
				//// in a checkerboard pattern
				//input.pos.xy = floor(input.pos.xy * 0.25) * 0.5;
				//float checker = -frac(input.pos.r + input.pos.g);

				//// clip HLSL instruction stops rendering a pixel if value is negative
				//clip(checker);

				//// for pixels that were kept, read the texture and output it
				////fixed4 c = tex2D(_MainTex, i.uv);
				////return c;
				final.a = _Transparency;
				return final;
			}
				
			ENDCG
		}
		
	}

}
