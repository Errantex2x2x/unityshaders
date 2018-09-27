Shader "Hidden/NegativePost"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NegativeAmount("Negative Amount", Range(0,1)) = 0.4
	}
	SubShader
	{
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			sampler2D _MainTex;
			half _NegativeAmount;
			
			
			fixed4 frag (v2f_img i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col = lerp(col, 1 - col, _NegativeAmount);
				
				return col;
			}
			ENDCG
		}
	}
}
