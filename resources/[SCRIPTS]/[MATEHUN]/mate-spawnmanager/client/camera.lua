local Camera = {}
Camera.cam = nil


function Camera.StartDeathCam()
     ClearFocus()
     local mypos = GetEntityCoords(cache.ped)
     Camera.cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", mypos.x, mypos.y, mypos.z, 0, 0, 0, GetGameplayCamFov(),
          true, 0)

     RenderScriptCams(true, true, 1000, true, true)
end

function Camera.Destroy()
     ClearFocus()
     RenderScriptCams(false, false, 0, false, false)
     DestroyCam(Camera.cam, false)
     Camera.cam = nil
end

exports("camDestory", Camera.Destroy)
return Camera
