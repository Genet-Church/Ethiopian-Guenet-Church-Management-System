import { useEffect } from 'react';
import { useBlocker } from 'react-router-dom';
import { useLanguage } from '../context/LanguageContext';

export function useLeaveConfirm(isDirty: boolean) {
  const { t } = useLanguage();

  // Block client-side navigation
  const blocker = useBlocker(
    ({ currentLocation, nextLocation }) =>
      isDirty && currentLocation.pathname !== nextLocation.pathname
  );

  useEffect(() => {
    if (blocker.state === 'blocked') {
      const confirmMsg = t('common.discardChanges') || 'You have unsaved changes. Are you sure you want to discard them and leave?';
      if (window.confirm(confirmMsg)) {
        blocker.proceed();
      } else {
        blocker.reset();
      }
    }
  }, [blocker, t]);

  // Block tab close / reload
  useEffect(() => {
    const handleBeforeUnload = (e: BeforeUnloadEvent) => {
      if (isDirty) {
        e.preventDefault();
        e.returnValue = ''; // Standard way to show browser prompt
      }
    };

    window.addEventListener('beforeunload', handleBeforeUnload);
    return () => window.removeEventListener('beforeunload', handleBeforeUnload);
  }, [isDirty]);
}
