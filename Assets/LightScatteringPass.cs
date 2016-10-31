using UnityEngine;
using System.Collections;

public class LightScatteringPass : MonoBehaviour {
    [SerializeField]
    private Material standardSolid;
    [SerializeField]
    private Material skybox;
    [SerializeField]
    private Texture source;
    [SerializeField]
    private RenderTexture dest;

    private Renderer[] renderers;
    private Material[] preMaterials;
    private Color skyColor1;
    private Color skyColor2;

    void Start() {
        renderers = FindObjectsOfType<Renderer>() as Renderer[];
        preMaterials = new Material[renderers.Length];
        for (int i = 0; i < preMaterials.Length; ++i) {
            preMaterials[i] = renderers[i].material;
        }
        skyColor1 = skybox.GetColor("_SkyColor1");
        skyColor2 = skybox.GetColor("_SkyColor2");
    }

    void OnPreRender() {
        foreach (Renderer r in renderers) {
            r.material = standardSolid;
        }

        skybox.SetColor("_SkyColor1", Color.black);
        skybox.SetColor("_SkyColor2", Color.black);
    }
    
    void Update() {
        Graphics.Blit(source, dest);
    }

    void OnPostRender() {
        skybox.SetColor("_SkyColor1", skyColor1);
        skybox.SetColor("_SkyColor2", skyColor2);

        for (int i = 0; i < preMaterials.Length; ++i) {
            renderers[i].material = preMaterials[i];
        }
    }

}
