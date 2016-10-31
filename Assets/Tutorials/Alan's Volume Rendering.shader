// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Alan's Volume Rendering" {
	Properties {
        _Centre("Centre", Vector) = (0.0, 0.0, 0.0)
        _Radius("Radius", Range(0, 10)) = 0.5
        _Color("Color", Color) = (0.5, 0.5, 0.5, 1)
        _SpecularPower("SpecularPower", Range(0, 10)) = 1
        _Gloss("Gloss", Range(0, 10)) = 1
	}
	SubShader {
		Pass {
            Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
            #include "Lighting.cginc"

            #define STEPS 64
            #define STEP_SIZE 0.01
            #define MIN_DISTANCE 0.001

            float3 _Centre;
            float _Radius;
            float4 _Color;
            float _SpecularPower;
            float _Gloss;

            struct v2f {
                float4 pos : SV_POSITION;	// Clip space
                float3 wPos : TEXCOORD1;	// World position
            };

            fixed4 simpleLambert(fixed3 normal, float3 viewDirection) {
                // I have to change the sign on the light direction. Don't know why.
                fixed3 lightDir = -_WorldSpaceLightPos0.xyz;	// Light direction
                fixed3 lightCol = _LightColor0.rgb;		// Light color

                fixed NdotL = max(dot(normal, lightDir),0);
                // Specular
                fixed3 h = (lightDir - viewDirection) / 2.;
                fixed s = pow( dot(normal, h), _SpecularPower) * _Gloss;
                fixed4 c;
                c.rgb = _Color * lightCol * NdotL + s;
                c.a = 1;
                return c;
            }

            float map(float3 p) {
                return distance(p, _Centre) - _Radius;
            }

            float3 normal (float3 p) {
                const float eps = 0.01;

                return normalize
                (	float3
                    (	map(p + float3(eps, 0, 0)) - map(p - float3(eps, 0, 0)),
                        map(p + float3(0, eps, 0)) - map(p - float3(0, eps, 0)),
                        map(p + float3(0, 0, eps)) - map(p - float3(0, 0, eps))
                    )
                );
            }

            fixed4 renderSurface(float3 p, float3 viewDirection) {
                float3 n = normal(p);
                return simpleLambert(n, viewDirection);
            }

            fixed4 raymarch (float3 position, float3 direction) {
                for (int i = 0; i < STEPS; i++) {
                    float distance = map(position);
                    if (distance < MIN_DISTANCE)
                        return renderSurface(position, direction);
                    position += distance * direction;
                }
                return 0;
            }

            v2f vert(appdata_full v) {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float3 worldPosition = i.wPos;
                float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
                return raymarch(worldPosition, viewDirection);
            }
			ENDCG
		}
	}
}
