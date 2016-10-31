Shader "Custom/God Rays"
{
	Properties
	{
        _RealTexture("RealTexture", 2D) = "white" {}
		_LightPassTexture ("Light Pass Texture", 2D) = "black" {}
        _Decay("Decay", Range(0, 5)) = 0.96815
        _Exposure("Exposure", Range(0, 1)) = 0.2
        _Density("Density", Range(0, 5)) = 0.926
        _Weight("Weight", Range(0, 1)) = 0.58767
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

            /// NUM_SAMPLES will describe the rays quality
            #define NUM_SAMPLES 100;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
                float2 lightScreenPosition : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
                o.lightScreenPosition = mul(UNITY_MATRIX_MVP, _WorldSpaceLightPos0);
				return o;
			}
			
            sampler2D _RealTexture;
			sampler2D _LightPassTexture;
            float _Decay;
            float _Exposure;
            float _Density;
            float _Weight;

			fixed4 frag (v2f x) : SV_Target
			{
                float2 tc = x.uv;
                float2 deltaTexCoord = tc - x.lightScreenPosition;
                deltaTexCoord *= 1.0 / NUM_SAMPLES;
                deltaTexCoord *= _Density;
                float illuminationDecay = 1.0;
                float4 color = tex2D(_LightPassTexture, tc) * 0.4;
                for (int i = 0; i < 100; ++i) {
                    tc -= deltaTexCoord;
                    float4 samp = tex2D(_LightPassTexture, tc)*0.4;
                    samp *= illuminationDecay * _Weight;
                    color += samp;
                    illuminationDecay *= _Decay;
                }
				return color + tex2D(_RealTexture, x.uv);
			}
			ENDCG
		}
	}
}
