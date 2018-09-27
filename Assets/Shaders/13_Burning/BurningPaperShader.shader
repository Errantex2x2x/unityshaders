Shader "Custom/Cg BurningPaperShader" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		
		[Header(Burning Paper)]
		_FlameTex("Flame texture", 2D) = "white" {}
		_FlameColor("Flame color", Color) = (1,.2,.1,1)
		_BurningMask("Burning mask", 2D) = "white" {}
		_BurnStatus("Burn status", Range(0,1)) = 0.2
		_SmokeResistance("Smoke resistance", Range(0,10)) = 1.0
		_FlameResistance("Flame resistance", Range(0,10)) = 5.0
		_DestructionResistance("Destruction resistance", Range(0,1)) = .9
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		Cull Off

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex; 
		sampler2D _FlameTex;
		sampler2D _BurningMask;

		struct Input {
			float2 uv_MainTex;
			float2 uv_FlameTex;
			float2 uv_BurningMask;
		};

		half _Glossiness;
		half _Metallic;
		half _BurnStatus;
		half _FireAggressiveness;
		half _SmokeResistance;
		half _FlameResistance;
		half _DestructionResistance;
		fixed4 _Color; 
		fixed4 _FlameColor;

		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			
			float maskValue = tex2D(_BurningMask, IN.uv_BurningMask).r; //oscillating from 0 to 1
			
			float burnAmount = _BurnStatus * 2 - 1;//Remapping from -1 to 1
			burnAmount += maskValue;
			burnAmount = clamp(burnAmount, 0, 1);

			//Smoke
			float smokeAmount = pow(burnAmount, _SmokeResistance);
			c = lerp(c, 0, clamp(smokeAmount, 0, 1));

			//Flame
			float flameAmount = pow(burnAmount, _FlameResistance);
			fixed4 flameColor = tex2D(_FlameTex, IN.uv_FlameTex) * _FlameColor; //oscillating from 0 to 1
			c = lerp(c, flameColor, clamp(floor(flameAmount + .5), 0, 1));
			
			//Clip
			clip(_DestructionResistance - burnAmount);


			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
